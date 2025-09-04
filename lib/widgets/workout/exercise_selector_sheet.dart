import 'package:flutter/material.dart';
// TODO: Import your exercise models/services here
// TODO: Import your database/drift classes here

class ExerciseSelectorSheet {
  static Future<void> show(
    BuildContext context, {
    Function(dynamic exercise)? onExerciseSelected,
  }) async {
    final theme = Theme.of(context);

    // TODO: Replace with your exercise data source
    // Example: final exerciseDao = context.read<AppDatabase>().exerciseDao;
    // Example: final exercises = await exerciseDao.getAllExercises();
    final exercises = await _getExercises();
    final categories = _groupExercisesByCategory(exercises);

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
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
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

    if (chosenCategory == null) return;

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
                      color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                      thickness: 1,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final exercise = categoryExercises[index];
                      
                      return ListTile(
                        title: Text(
                          // TODO: Replace with your exercise name field
                          exercise.toString(), // exercise.name
                          style: theme.textTheme.bodyLarge,
                        ),
                        subtitle: exercise is Map && exercise.containsKey('instructions') 
                          ? Text(
                              exercise['instructions'] ?? '',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
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

  // TODO: Replace with your actual database query
  static Future<List<dynamic>> _getExercises() async {
    // Placeholder - replace with your Drift database call
    // Example: return await database.exerciseDao.getAllExercises();
    return [
      // Placeholder data structure
      {'name': 'Bench Press', 'category': 'Chest', 'instructions': 'Lie on bench...'},
      {'name': 'Squats', 'category': 'Legs', 'instructions': 'Stand with feet...'},
      {'name': 'Deadlift', 'category': 'Back', 'instructions': 'Stand with feet...'},
      // Add more exercises...
    ];
  }

  // TODO: Update this method to work with your exercise data structure
  static Map<String, List<dynamic>> _groupExercisesByCategory(List<dynamic> exercises) {
    final Map<String, List<dynamic>> categories = {};
    
    for (final exercise in exercises) {
      // TODO: Replace with your category field access
      final category = exercise is Map 
          ? exercise['category'] ?? 'Other'
          : 'Other'; // exercise.category
      
      categories.putIfAbsent(category, () => []).add(exercise);
    }
    
    // Sort categories alphabetically
    final sortedCategories = Map.fromEntries(
      categories.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );
    
    return sortedCategories;
  }

  // Alternative static method with direct database access
  static Future<void> showWithDatabase(
    BuildContext context, {
    required Function(dynamic exercise) onExerciseSelected,
    // TODO: Add your database parameter
    // required AppDatabase database,
  }) async {
    // TODO: Implement direct database access version
    // final exercises = await database.exerciseDao.getAllExercises();
    // ... rest of implementation
  }
}