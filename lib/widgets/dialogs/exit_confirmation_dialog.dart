import 'package:chronolift/models/workout_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExitConfirmationDialog {
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit Workout?"),
          content: const Text(
            "Are you sure you want to exit? Your workout progress will be lost.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final workoutState = context.read<WorkoutStateModel>();
                workoutState.cancelWorkout();
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
    return result ?? false; // Default to false if dialog is dismissed
  }
}
