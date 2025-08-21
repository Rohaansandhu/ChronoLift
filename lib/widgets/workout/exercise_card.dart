import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/workout_state.dart';
import 'package:chronolift/widgets/workout/inline_editable_field.dart';

class ExerciseCard extends StatelessWidget {
  final int exerciseIndex;
  final Map<String, dynamic> exercise;

  const ExerciseCard({
    super.key,
    required this.exerciseIndex,
    required this.exercise,
  });

  void _addNewSet(BuildContext context) {
    final workoutState = context.read<WorkoutState>();
    workoutState.addSet(exerciseIndex, 0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = context.watch<WorkoutState>();
    final sets = exercise["sets"] as List;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise["name"],
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
                    Expanded(
                      child: InlineEditableField(
                        exerciseIndex: exerciseIndex,
                        setIndex: setIndex,
                        fieldType: "reps",
                        value: set['reps'].toString(),
                        label: "Reps",
                        onChanged: (value) {
                          workoutState.updateSet(
                            exerciseIndex,
                            setIndex,
                            int.tryParse(value) ?? 0,
                            set['weight']?.toDouble() ?? 0.0,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InlineEditableField(
                        exerciseIndex: exerciseIndex,
                        setIndex: setIndex,
                        fieldType: "weight",
                        value: set['weight'].toString(),
                        label: "Weight",
                        onChanged: (value) {
                          workoutState.updateSet(
                            exerciseIndex,
                            setIndex,
                            set['reps'] ?? 0,
                            double.tryParse(value) ?? 0.0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
            
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