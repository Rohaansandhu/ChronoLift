import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Statistics"),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(child: Text("Stats will appear here... ")));
  }
}
