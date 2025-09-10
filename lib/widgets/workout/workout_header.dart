import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/workout_state.dart';

class WorkoutHeader extends StatefulWidget {
  const WorkoutHeader({super.key});

  @override
  State<WorkoutHeader> createState() => _WorkoutHeaderState();
}

class _WorkoutHeaderState extends State<WorkoutHeader> {
  late TextEditingController _nameController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final workoutState = context.read<WorkoutStateModel>();

    _nameController = TextEditingController(text: workoutState.name ?? "");
    _notesController = TextEditingController(text: workoutState.notes ?? "");
  }

  @override
  void didUpdateWidget(covariant WorkoutHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    final workoutState = context.read<WorkoutStateModel>();

    // Keep controllers in sync with state if changed externally
    if (_nameController.text != (workoutState.name ?? "")) {
      _nameController.text = workoutState.name ?? "";
      _nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nameController.text.length),
      );
    }

    if (_notesController.text != (workoutState.notes ?? "")) {
      _notesController.text = workoutState.notes ?? "";
      _notesController.selection = TextSelection.fromPosition(
        TextPosition(offset: _notesController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = context.watch<WorkoutStateModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Workout name
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: "Workout Name"),
          onChanged: workoutState.updateName,
        ),
        const SizedBox(height: 10),

        // Show start/end times if workout has started
        if (workoutState.startTime != null)
          Text(
            "Start: ${workoutState.startTime!.toLocal()}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (workoutState.endTime != null)
          Text(
            "End: ${workoutState.endTime!.toLocal()}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),

        const SizedBox(height: 10),

        // Notes
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(labelText: "Notes"),
          onChanged: workoutState.updateNotes,
          maxLines: null,
        ),
      ],
    );
  }
}
