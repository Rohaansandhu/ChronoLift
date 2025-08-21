import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/exercise_model.dart';
import '../../models/workout_state.dart';

class ExerciseSelectorSheet {
  static Future<void> show(BuildContext context) async {
    final exerciseModel = context.read<ExerciseModel>();
    final workoutState = context.read<WorkoutState>();
    final theme = Theme.of(context);

    // Step 1: Category bottom sheet
    final chosenCategory = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return ListView.separated(
              controller: scrollController,
              itemCount: exerciseModel.categories.keys.length + 1,
              separatorBuilder: (_, __) => Divider(
                color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                thickness: 1,
                height: 1,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Select Category",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                final cat = exerciseModel.categories.keys.elementAt(index - 1);
                return ListTile(
                  title: Text(
                    cat,
                    style: theme.textTheme.bodyLarge,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: theme.colorScheme.tertiary),
                  onTap: () => Navigator.pop(context, cat),
                );
              },
            );
          },
        );
      },
    );

    if (chosenCategory == null) return;

    // Step 2: Exercise bottom sheet
    final chosenExercise = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            final exercises = exerciseModel.categories[chosenCategory]!;

            return ListView.separated(
              controller: scrollController,
              itemCount: exercises.length + 1,
              separatorBuilder: (_, __) => Divider(
                color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                thickness: 1,
                height: 1,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Select Exercise From $chosenCategory",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                final ex = exercises[index - 1].toString();
                return ListTile(
                  title: Text(
                    ex,
                    style: theme.textTheme.bodyLarge,
                  ),
                  onTap: () => Navigator.pop(context, ex),
                );
              },
            );
          },
        );
      },
    );

    if (chosenExercise != null) {
      workoutState.addExercise(chosenExercise);
    }
  }
}