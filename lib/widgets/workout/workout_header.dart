import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/workout_state.dart';

class WorkoutHeader extends StatelessWidget {
  const WorkoutHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workoutState = context.watch<WorkoutState>();
    
    return Column(
      children: [
        TextField(
          controller: workoutState.nameController,
          decoration: const InputDecoration(labelText: "Workout Name"),
        ),
        const SizedBox(height: 10),
        Text("Start: ${workoutState.startTime.toLocal()}"),
        if (workoutState.endTime != null)
          Text("End: ${workoutState.endTime!.toLocal()}"),
        const SizedBox(height: 10),
        DropdownButton<String>(
          hint: const Text("Select Routine (optional)"),
          value: workoutState.selectedRoutine,
          items: ["Push", "Pull", "Legs"]
              .map((r) => DropdownMenuItem(value: r, child: Text(r)))
              .toList(),
          onChanged: (val) {
            workoutState.selectedRoutine = val;
            workoutState.notifyListeners();
          },
        ),
      ],
    );
  }
}