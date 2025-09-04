import 'package:flutter/material.dart';
// TODO: Import your workout models/state management here
// TODO: Import your set models here
import 'package:chronolift/widgets/workout/inline_editable_field.dart';

class ExerciseCard extends StatelessWidget {
  final int exerciseIndex;
  final dynamic exercise; // TODO: Replace with your Exercise/WorkoutExercise type
  
  // TODO: Add callback functions for state management
  final VoidCallback? onAddSet;
  final Function(int setIndex, Map<String, dynamic> setData)? onUpdateSet;
  final Function(int setIndex)? onDeleteSet;

  const ExerciseCard({
    super.key,
    required this.exerciseIndex,
    required this.exercise,
    this.onAddSet,
    this.onUpdateSet,
    this.onDeleteSet,
  });

  void _addNewSet() {
    // TODO: Implement add set logic
    // Example: onAddSet?.call();
    // Or: context.read<WorkoutProvider>().addSet(exerciseIndex);
    onAddSet?.call();
  }

  void _updateSet(int setIndex, String field, String value) {
    // TODO: Implement set update logic
    // Create the updated set data
    final setData = <String, dynamic>{};
    
    // TODO: Get current set data and update the specific field
    // Example:
    // final currentSet = exercise.sets[setIndex];
    // setData.addAll(currentSet.toMap());
    
    switch (field) {
      case 'weight':
        setData['weight'] = double.tryParse(value) ?? 0.0;
        break;
      case 'reps':
        setData['reps'] = int.tryParse(value) ?? 0;
        break;
      case 'notes':
        setData['notes'] = value;
        break;
    }
    
    onUpdateSet?.call(setIndex, setData);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with your exercise data structure
    final exerciseName = exercise?.name ?? 'Exercise'; // exercise.name
    final sets = <dynamic>[]; // TODO: Replace with exercise.sets or similar
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exerciseName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // TODO: Add exercise options menu if needed
                // PopupMenuButton(...)
              ],
            ),
            const SizedBox(height: 12),
            
            // Header row with labels
            if (sets.isNotEmpty) ...[
              Row(
                children: [
                  const SizedBox(width: 32), // Space for set number
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 80,
                    child: Text(
                      "Weight",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 80,
                    child: Text(
                      "Reps",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Notes",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Space for delete button
                ],
              ),
              const SizedBox(height: 8),
            ],
            
            // Display existing sets with inline editing
            ...sets.asMap().entries.map((entry) {
              final setIndex = entry.key;
              final set = entry.value;
              
              // TODO: Replace with your set data structure
              final weight = set['weight']?.toString() ?? '0'; // set.weight.toString()
              final reps = set['reps']?.toString() ?? '0'; // set.reps.toString()
              final notes = set['notes']?.toString() ?? ''; // set.notes ?? ''
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text(
                      "${setIndex + 1}:",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 80,
                      child: InlineEditableField(
                        exerciseIndex: exerciseIndex,
                        setIndex: setIndex,
                        fieldType: "weight",
                        value: weight,
                        label: "",
                        onChanged: (value) => _updateSet(setIndex, 'weight', value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 80,
                      child: InlineEditableField(
                        exerciseIndex: exerciseIndex,
                        setIndex: setIndex,
                        fieldType: "reps",
                        value: reps,
                        label: "",
                        onChanged: (value) => _updateSet(setIndex, 'reps', value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InlineEditableField(
                        exerciseIndex: exerciseIndex,
                        setIndex: setIndex,
                        fieldType: "notes",
                        value: notes,
                        label: "",
                        onChanged: (value) => _updateSet(setIndex, 'notes', value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Delete set button
                    IconButton(
                      onPressed: () => onDeleteSet?.call(setIndex),
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                  ],
                ),
              );
            }),
            
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: _addNewSet,
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