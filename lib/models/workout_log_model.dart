import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutLogModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final int _pageSize = 20;
  DocumentSnapshot? _lastDocument;
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
    _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : _lastDocument;
    _hasMore = snapshot.docs.length == _pageSize;
    _isLoadingMore = false;

    notifyListeners();
  }

  Future<void> refreshLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Reset pagination state
    _lastDocument = null;
    _hasMore = true;
    _isLoadingMore = false;

    // Reload initial logs
    await loadInitialLogs();
  }
}
