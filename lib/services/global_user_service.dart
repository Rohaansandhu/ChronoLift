import 'package:chronolift/database/dao/user_dao.dart';
import 'package:chronolift/database/database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

// Global User Service - Singleton pattern
class GlobalUserService {
  static GlobalUserService? _instance;
  static GlobalUserService get instance => _instance ??= GlobalUserService._();

  GlobalUserService._();

  // Private variables
  User? _currentUser;
  UserDao? _userDao;
  AppDatabase? _database;

  // Initialize the service with database access
  void initialize(AppDatabase database) {
    _database = database;
    _userDao = UserDao(database);
  }

  // Get current user (cached)
  User? get currentUser => _currentUser;

  // Get current user's UUID
  String? get currentUserUuid => _currentUser?.uuid;

  // Get current user's email
  String? get currentUserEmail => _currentUser?.email;

  // Get current user's ID
  int? get currentUserId => _currentUser?.id;

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Load current user from database
  Future<User?> loadCurrentUser() async {
    if (_userDao == null) {
      throw Exception(
          'GlobalUserService not initialized. Call initialize() first.');
    }

    _currentUser = await _userDao!.getCurrentUser();
    return _currentUser;
  }

  // Set current user (updates database and cache)
  Future<void> setCurrentUser(int userId) async {
    if (_userDao == null) {
      throw Exception(
          'GlobalUserService not initialized. Call initialize() first.');
    }

    // Update database
    await _userDao!.setCurrentUser(userId, true);

    // Update cache
    _currentUser = await _userDao!.getUserById(userId);
  }

  // Set current user by UUID (useful after Supabase auth)
  Future<void> setCurrentUserByUuid(String uuid) async {
    if (_userDao == null) {
      throw Exception(
          'GlobalUserService not initialized. Call initialize() first.');
    }

    final user = await _userDao!.getUserByUuid(uuid);
    if (user != null) {
      await setCurrentUser(user.id);
    } else {
      throw Exception('User with UUID $uuid not found in local database');
    }
  }

  // Set current user by email (used for login )
  Future<void> setCurrentUserByEmail(String? email) async {
    if (_userDao == null) {
      throw Exception(
          'GlobalUserService not initialized. Call initialize() first.');
    }
    if (email == null) {
      throw Exception('User email is null');
    }
    final user = await _userDao!.getUserByEmail(email);
    if (user != null) {
      await setCurrentUser(user.id);
    } else {
      throw Exception('User with email $email not found in local database');
    }
  }

  // Clear current user (logout)
  Future<void> clearCurrentUser() async {
    if (_userDao == null || _currentUser == null) return;

    // Update database
    await _userDao!.setCurrentUser(_currentUser!.id, false);

    // Clear cache
    _currentUser = null;
  }

  // Add or update user in local database (useful after registration/login)
  Future<User> upsertUser({
    required String uuid,
    required String email,
    bool setAsCurrent = true,
  }) async {
    if (_userDao == null) {
      throw Exception(
          'GlobalUserService not initialized. Call initialize() first.');
    }

    // Insert or update user
    await _userDao!.upsertUser(
      UsersCompanion(
        uuid: Value(uuid),
        email: Value(email),
        isCurrent: Value(setAsCurrent),
      ),
    );

    // Get the user back from database
    final user = await _userDao!.getUserByUuid(uuid);

    if (user == null) {
      throw Exception('Failed to create/update user');
    }

    // If setting as current, clear other current users and update cache
    if (setAsCurrent) {
      await _userDao!.setCurrentUser(user.id, true);
      _currentUser = user;
    }

    return user;
  }

  // Refresh current user from database (useful after updates)
  Future<User?> refreshCurrentUser() async {
    if (_currentUser == null || _userDao == null) return null;

    _currentUser = await _userDao!.getUserById(_currentUser!.id);
    return _currentUser;
  }

  // Watch current user changes (returns a stream)
  Stream<User?> watchCurrentUser() async* {
    if (_userDao == null) {
      throw Exception(
          'GlobalUserService not initialized. Call initialize() first.');
    }

    await for (final users in _userDao!.watchAllUsers()) {
      final currentUser = users.where((u) => u.isCurrent).firstOrNull;
      _currentUser = currentUser;
      yield currentUser;
    }
  }
}

// Global getter for easy access
GlobalUserService get globalUser => GlobalUserService.instance;

// Extension to make database access easier
extension DatabaseGlobalUser on AppDatabase {
  GlobalUserService get globalUser {
    GlobalUserService.instance.initialize(this);
    return GlobalUserService.instance;
  }
}
