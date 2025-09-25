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

  Future<void> _selectStartTime(BuildContext context, WorkoutStateModel workoutState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: workoutState.startTime ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(workoutState.startTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        workoutState.updateStartTime(newDateTime);
      }
    }
  }

  Future<void> _selectEndTime(BuildContext context, WorkoutStateModel workoutState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: workoutState.endTime ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(workoutState.endTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        workoutState.updateEndTime(newDateTime);
      }
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Not set (Will auto-set on finish)';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
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

        // Start time - editable
        Row(
          children: [
            Expanded(
              child: Text(
                "Start: ${_formatDateTime(workoutState.startTime)}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            IconButton(
              onPressed: () => _selectStartTime(context, workoutState),
              icon: const Icon(Icons.edit),
              tooltip: 'Edit start time',
            ),
          ],
        ),

        // End time - editable (only show if workout has started)
        if (workoutState.startTime != null)
          Row(
            children: [
              Expanded(
                child: Text(
                  "End: ${_formatDateTime(workoutState.endTime)}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              IconButton(
                onPressed: () => _selectEndTime(context, workoutState),
                icon: const Icon(Icons.edit),
                tooltip: 'Edit end time',
              ),
            ],
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