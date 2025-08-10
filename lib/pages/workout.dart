import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Workout"),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(child: Text("A workout page will appear here... ")));
  }
}