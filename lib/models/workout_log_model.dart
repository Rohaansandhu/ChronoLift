import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutLogModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final int _pageSize = 20;
  DocumentSnapshot? _lastDocument;
  DocumentSnapshot? _firstDocument;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  List<DocumentSnapshot> _logs = [];
  List<DocumentSnapshot> get logs => _logs;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  WorkoutLogModel() {
    loadInitialLogs();
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  }

  Future<void> loadInitialLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .orderBy('date', descending: true)
        .limit(_pageSize)
        .get();

    _logs = snapshot.docs;
    _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    _firstDocument = snapshot.docs.isNotEmpty
        ? snapshot.docs.first
        : null; // Track most recent
    _hasMore = snapshot.docs.length == _pageSize;

    notifyListeners();
  }

  Future<void> loadMoreLogs() async {
    if (!_hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .orderBy('date', descending: true)
        .startAfterDocument(_lastDocument!)
        .limit(_pageSize)
        .get();

    _logs.addAll(snapshot.docs);
    _lastDocument =
        snapshot.docs.isNotEmpty ? snapshot.docs.last : _lastDocument;
    _hasMore = snapshot.docs.length == _pageSize;
    _isLoadingMore = false;

    notifyListeners();
  }

  Future<void> refreshLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // If we don't have any logs yet, do a full initial load
    if (_firstDocument == null) {
      await loadInitialLogs();
      return;
    }

    // Get the date of our most recent log
    final firstLogData = _firstDocument!.data() as Map<String, dynamic>;
    final firstLogDate = firstLogData['date'] as Timestamp;

    // Query for logs newer than our most recent one
    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .orderBy('date', descending: true)
        .where('date', isGreaterThan: firstLogDate) // Only get newer logs
        .get();

    // If there are new logs, add them to the beginning of our list
    if (snapshot.docs.isNotEmpty) {
      print("Found ${snapshot.docs.length} new logs"); // TODO: Create logging system

      // Insert new logs at the beginning (they're already in descending order)
      _logs.insertAll(0, snapshot.docs);

      // Update our first document to the newest one
      _firstDocument = snapshot.docs.first;

      notifyListeners();
    }
  }

  // Optional: Add a method to force a complete refresh if needed
  Future<void> forceFullRefresh() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Reset pagination state
    _lastDocument = null;
    _firstDocument = null;
    _hasMore = true;
    _isLoadingMore = false;

    // Reload initial logs
    await loadInitialLogs();
  }
}
