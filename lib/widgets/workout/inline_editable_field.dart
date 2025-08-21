import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/workout_state.dart';

class InlineEditableField extends StatelessWidget {
  final int exerciseIndex;
  final int setIndex;
  final String fieldType; // weight, reps, notes
  final String value;
  final String label;
  final Function(String) onChanged;

  const InlineEditableField({
    super.key,
    required this.exerciseIndex,
    required this.setIndex,
    required this.fieldType,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final workoutState = context.watch<WorkoutState>();
    final fieldId = "${exerciseIndex}_${setIndex}_$fieldType";
    final isEditing =
        workoutState.isFieldEditing(exerciseIndex, setIndex, fieldType);

    if (isEditing) {
      final bool showDefaultValue = value == "0" || value == "0.0" || value == "";
      final controller = TextEditingController(
          text: showDefaultValue ? "" : value);

      return TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        onSubmitted: (newValue) {
          onChanged(newValue);
          workoutState.setEditingField(null);
        },
        onTapOutside: (_) {
          onChanged(controller.text);
          workoutState.setEditingField(null);
        },
      );
    }

    return InkWell(
      onTap: () {
        workoutState.setEditingField(fieldId);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          (value == "0" || value == "0.0") ? label : '$label: $value',
          style: TextStyle(
            color: value == "0"
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                : null,
          ),
        ),
      ),
    );
  }
}
