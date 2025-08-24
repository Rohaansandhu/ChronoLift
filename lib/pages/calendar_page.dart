import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calendar"),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(child: Text("Calendar page...")));
  }
}
