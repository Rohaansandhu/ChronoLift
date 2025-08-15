import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'workout.dart';
import 'package:shiny_button/shiny_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final int _pageSize = 20;
  DocumentSnapshot? _lastDocument;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  List<DocumentSnapshot> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadInitialLogs();
  }

void _logout() async {
  await _auth.signOut();
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Logged out successfully')),
  );
}

  Future<void> _loadInitialLogs() async {
    final snapshot = await _firestore
        .collection('workoutLogs')
        .orderBy('date', descending: true)
        .limit(_pageSize)
        .get();

    setState(() {
      _logs = snapshot.docs;
      _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      _hasMore = snapshot.docs.length == _pageSize;
    });
  }

  Future<void> _loadMoreLogs() async {
    if (!_hasMore || _isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    final snapshot = await _firestore
        .collection('workoutLogs')
        .orderBy('date', descending: true)
        .startAfterDocument(_lastDocument!)
        .limit(_pageSize)
        .get();

    setState(() {
      _logs.addAll(snapshot.docs);
      _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : _lastDocument;
      _hasMore = snapshot.docs.length == _pageSize;
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workout Log",
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          // Create New Workout Button
          SizedBox(
            height: 80,
            width: 275,
            child: ShinyButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const WorkoutPage()));
              },
              label: 'New Workout',
              icon: const Icon(Icons.add, color: Colors.black),
              backgroundColor: const Color(0xFFFFD6A5),
              textColor: Colors.black87,
              shineDirection: ShineDirection.leftToRight,
              iconPosition: IconPosition.leading,
              tooltip: 'Start a new workout',
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              borderRadius: 16.0,
              elevation: 4.0,
              shadowColor: Colors.black54,
            ),
          ),

          const SizedBox(height: 20),

          // Future Dashboard Section
          /*
          DashboardWidget(), // Your future highlights/milestones widget
          const SizedBox(height: 20),
          */

          // Scrollable Logs List
          Expanded(
            child: _logs.isEmpty
                ? const Center(child: Text("No Logs Yet..."))
                : NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent &&
                          !_isLoadingMore) {
                        _loadMoreLogs();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: _logs.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _logs.length) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final logData =
                            _logs[index].data() as Map<String, dynamic>;
                        final date = (logData['date'] as Timestamp).toDate();

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(logData['title'] ?? 'Workout'),
                            subtitle: Text(
                              "${date.toLocal()}",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
