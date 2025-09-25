import 'package:chronolift/database/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseSelectorSheet {
  static Future<void> show(
    BuildContext context, {
    Function(dynamic exercise)? onExerciseSelected,
  }) async {
    final theme = Theme.of(context);
    final database = Provider.of<AppDatabase>(context, listen: false);

    // Load categories asynchronously first
    final categories = await _groupExercisesByCategory(database);

    if (!context.mounted) return;

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
              itemCount: categories.keys.length + 1,
              separatorBuilder: (_, __) => Divider(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
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
                final category = categories.keys.elementAt(index - 1);
                final exerciseCount = categories[category]!.length;

                return ListTile(
                  title: Text(
                    category,
                    style: theme.textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    '$exerciseCount exercises',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.tertiary,
                  ),
                  onTap: () => Navigator.pop(context, category),
                );
              },
            );
          },
        );
      },
    );

    if (chosenCategory == null || !context.mounted) return;

    // Step 2: Exercise bottom sheet
    final chosenExercise = await showModalBottomSheet<dynamic>(
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
            final categoryExercises = categories[chosenCategory]!;

            return Column(
              children: [
                // Header with back button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Re-show category selector
                          show(context, onExerciseSelected: onExerciseSelected);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Text(
                          "Select Exercise From $chosenCategory",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Exercise list
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: categoryExercises.length,
                    separatorBuilder: (_, __) => Divider(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                      thickness: 1,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final exercise = categoryExercises[index];

                      return ListTile(
                        title: Text(
                          exercise.name,
                          style: theme.textTheme.bodyLarge,
                        ),
                        onTap: () => Navigator.pop(context, exercise),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (chosenExercise != null) {
      // Call the callback if provided
      onExerciseSelected?.call(chosenExercise);
    }
  }

  static Future<Map<String, List<Exercise>>> _groupExercisesByCategory(
      AppDatabase database) async {
    final categoryDao = database.categoryDao;
    final exerciseDao = database.exerciseDao;
    final categories = await categoryDao.getAllCategories();
    final Map<String, List<Exercise>> categoryExerciseMap = {};

    for (final category in categories) {
      final exercises = await exerciseDao.getExercisesByCategory(category.id);
      categoryExerciseMap[category.name] = exercises;
    }

    return categoryExerciseMap;
  }
}