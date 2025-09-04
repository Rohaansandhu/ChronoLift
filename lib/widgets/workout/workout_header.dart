import 'package:flutter/material.dart';

class WorkoutHeader extends StatelessWidget {
  final TextEditingController nameController;
  final DateTime startTime;
  final DateTime? endTime;
  final String? selectedRoutine;
  final List<String> availableRoutines;
  final Function(String?) onRoutineChanged;
  final Function(String)? onNameChanged;

  const WorkoutHeader({
    Key? key,
    required this.nameController,
    required this.startTime,
    this.endTime,
    this.selectedRoutine,
    this.availableRoutines = const ["Push", "Pull", "Legs"],
    required this.onRoutineChanged,
    this.onNameChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Workout Name"),
          onChanged: onNameChanged,
        ),
        const SizedBox(height: 10),
        Text(
          "Start: ${startTime.toLocal()}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (endTime != null)
          Text(
            "End: ${endTime!.toLocal()}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          hint: const Text("Select Routine (optional)"),
          value: selectedRoutine,
          isExpanded: true,
          items: availableRoutines
              .map((routine) => DropdownMenuItem(
                    value: routine,
                    child: Text(routine),
                  ))
              .toList(),
          onChanged: onRoutineChanged,
        ),
      ],
    );
  }
}