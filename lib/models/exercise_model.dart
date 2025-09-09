import 'package:chronolift/database/dao/category_dao.dart';
import 'package:flutter/material.dart';
import 'package:chronolift/database/database.dart';
import 'package:chronolift/database/dao/exercise_dao.dart';
import 'package:drift/drift.dart';

class ExerciseModel extends ChangeNotifier {
  final ExerciseDao _exerciseDao;
  final CategoryDao _categoryDao;

  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedCategory;

  // Getters
  List<Exercise> get exercises => _filteredExercises.isEmpty &&
          _searchQuery.isEmpty &&
          _selectedCategory == null
      ? _exercises
      : _filteredExercises;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;

  ExerciseModel(this._exerciseDao, this._categoryDao) {
    loadExercises();
    loadCategories();
  }

  // Load all exercises from database
  Future<void> loadExercises() async {
    _isLoading = true;
    notifyListeners();

    try {
      _exercises = await _exerciseDao.getAllExercises();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading exercises: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      _categories = await _categoryDao.getAllCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  // Search exercises
  void searchExercises(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  // Filter by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Apply all active filters
  void _applyFilters() {
    _filteredExercises = _exercises.where((exercise) {
      // Apply search filter
      bool matchesSearch = _searchQuery.isEmpty ||
          exercise.name.toLowerCase().contains(_searchQuery);

      // Apply category filter
      bool matchesCategory =
          _selectedCategory == null || exercise.categoryId == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _filteredExercises = [];
    notifyListeners();
  }

  // Add new exercise
  Future<bool> addExercise({
    required String name,
    required String uuid,
    String? categoryId,
    String? instructions,
  }) async {
    try {
      final id = await _exerciseDao.createExercise(
        ExercisesCompanion.insert(
          name: name,
          uuid: uuid,
          categoryId: Value(categoryId),
          instructions: Value(instructions),
        ),
      );

      // Reload exercises to get the new one
      await loadExercises();

      // Reload categories if new category was added
      if (categoryId != null && !_categories.contains(categoryId)) {
        await loadCategories();
      }

      return true;
    } catch (e) {
      debugPrint('Error adding exercise: $e');
      return false;
    }
  }

  // Update exercise
  Future<bool> updateExercise({
    required int id,
    String? name,
    String? categoryId,
    String? instructions,
  }) async {
    try {
      await _exerciseDao.updateExercise(
        id,
        ExercisesCompanion(
          name: name != null ? Value(name) : const Value.absent(),
          categoryId: Value(categoryId),
          instructions: Value(instructions),
        ),
      );

      await loadExercises();

      if (categoryId != null && !_categories.contains(categoryId)) {
        await loadCategories();
      }

      return true;
    } catch (e) {
      debugPrint('Error updating exercise: $e');
      return false;
    }
  }

  // Delete exercise
  Future<bool> deleteExercise(int id) async {
    try {
      await _exerciseDao.deleteExercise(id);
      await loadExercises();
      return true;
    } catch (e) {
      debugPrint('Error deleting exercise: $e');
      return false;
    }
  }

  // Get exercise by ID
  Exercise? getExerciseById(int id) {
    try {
      return _exercises.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // Check if exercise name exists (for validation)
  bool exerciseNameExists(String name, {int? excludeId}) {
    return _exercises.any((e) =>
        e.name.toLowerCase() == name.toLowerCase() &&
        (excludeId == null || e.id != excludeId));
  }

  void dispose() {
    super.dispose();
  }
}
