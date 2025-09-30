import 'package:chronolift/database/database.dart';
import 'package:chronolift/services/global_user_service.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExerciseDialog {
  static Future<Exercise?> show(BuildContext context, {required int categoryId, required String categoryName}) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController instructionsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog<Exercise>(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        
        return AlertDialog(
          title: Text(
            'Add New Exercise',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Category: $categoryName',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Exercise name
                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Exercise Name',
                      hintText: 'e.g., Barbell Bench Press',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.fitness_center),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an exercise name';
                      }
                      if (value.trim().length < 2) {
                        return 'Exercise name must be at least 2 characters';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  // Instructions
                  TextFormField(
                    controller: instructionsController,
                    decoration: InputDecoration(
                      labelText: 'Instructions (Optional)',
                      hintText: 'How to perform this exercise',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.description),
                    ),
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final exerciseName = nameController.text.trim();
                  final instructions = instructionsController.text.trim();
                  final database = context.read<AppDatabase>();
                  final exerciseDao = database.exerciseDao;
                  
                  try {
                    // Get current user UUID
                    final globalUser = GlobalUserService.instance;
                    final uuid = globalUser.currentUserUuid!;

                    // Create the exercise
                    final exerciseId = await exerciseDao.createExercise(
                      ExercisesCompanion.insert(
                        uuid: uuid,
                        name: exerciseName,
                        categoryId: categoryId,
                        instructions: drift.Value(instructions.isNotEmpty ? instructions : null),
                      ),
                    );

                    // Fetch the created exercise to return it
                    final exercises = await exerciseDao.getAllExercises();
                    final createdExercise = exercises.firstWhere((e) => e.id == exerciseId);

                    if (context.mounted) {
                      Navigator.of(context).pop(createdExercise);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Exercise "$exerciseName" created successfully'),
                          backgroundColor: theme.colorScheme.primary,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      // Check if it's a unique constraint error
                      final errorMessage = e.toString().contains('UNIQUE constraint')
                          ? 'An exercise with this name already exists'
                          : 'Error creating exercise: $e';
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                          backgroundColor: theme.colorScheme.error,
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}