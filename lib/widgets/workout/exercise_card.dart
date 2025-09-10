import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/workout_state.dart';
import 'package:chronolift/widgets/workout/inline_editable_field.dart';

class ExerciseCard extends StatelessWidget {
  final int exerciseIndex;

  const ExerciseCard({
    super.key,
    required this.exerciseIndex,
  });

  Future<void> _addNewSet(BuildContext context) async {
    final workoutState = context.read<WorkoutStateModel>();
    // get the WorkoutExerciseState from the provider and pass it to addSet
    final exerciseState = workoutState.exercises[exerciseIndex];
    await workoutState.addSet(exerciseState);
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = context.watch<WorkoutStateModel>();

    // guard: make sure index is valid
    if (exerciseIndex < 0 || exerciseIndex >= workoutState.exercises.length) {
      return const SizedBox.shrink();
    }

    final exerciseState = workoutState.exercises[exerciseIndex];
    final sets = exerciseState.sets;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exerciseState.exercise.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Display existing sets with inline editing
            ...sets.asMap().entries.map((entry) {
              final setIndex = entry.key;
              final set = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Set ${setIndex + 1}:",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(width: 12),

                    // Reps field
                    Expanded(
                      child: InlineEditableField(
                        exerciseIndex: exerciseIndex,
                        setIndex: setIndex,
                        fieldType: "reps",
                        value: set.reps?.toString() ?? '',
                        label: "Reps",
                        onChanged: (value) {
                          final reps = int.tryParse(value) ?? 0;
                          // use named params for updateSet
                          workoutState.updateSet(
                            exerciseIndex,
                            setIndex,
                            reps: reps,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Weight field
                    Expanded(
                      child: InlineEditableField(
                        exerciseIndex: exerciseIndex,
                        setIndex: setIndex,
                        fieldType: "weight",
                        value: set.weight?.toString() ?? '',
                        label: "Weight",
                        onChanged: (value) {
                          final weight = double.tryParse(value) ?? 0.0;
                          // use named params for updateSet
                          workoutState.updateSet(
                            exerciseIndex,
                            setIndex,
                            weight: weight,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () => _addNewSet(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Add Set"),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
