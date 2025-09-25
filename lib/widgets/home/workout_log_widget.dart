import 'package:chronolift/database/dao/workout_dao.dart';
import 'package:chronolift/database/database.dart';
import 'package:chronolift/models/workout_log_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutLogCard extends StatelessWidget {
  final Workout workout; // From Drift
  final List<WorkoutExerciseWithSets> exercises; // Joined list from Drift query

  const WorkoutLogCard({
    super.key,
    required this.workout,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime workoutDate = workout.date; // Already a DateTime
    final String workoutName = workout.name ?? 'Unnamed Workout';
    final int durationMinutes = _calculateDuration();
    final List<String> exerciseNames =
        exercises.map((e) => e.exercise.name).toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalendarSection(workoutDate),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          workoutName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (workout.startTime != null && workout.endTime != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${durationMinutes}m',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      // Delete button aligned to right
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          onPressed: () => _deleteWorkout(context, workout.id),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildExerciseList(exerciseNames, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection(DateTime workoutDate) {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD6A5).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFFD6A5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 20, color: Colors.grey[700]),
          const SizedBox(height: 4),
          Text(
            _getMonthAbbreviation(workoutDate.month),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            workoutDate.day.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _getDayOfWeekAbbreviation(workoutDate.weekday),
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList(List<String> exerciseNames, BuildContext context) {
    if (exerciseNames.isEmpty) {
      return Text(
        'No exercises recorded',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
      );
    }

    const int maxVisible = 4;
    final visibleExercises = exerciseNames.take(maxVisible).toList();
    final remainingCount = exerciseNames.length - maxVisible;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...visibleExercises.map(
          (exercise) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              exercise,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                  ),
            ),
          ),
        ),
        if (remainingCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+$remainingCount more',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
            ),
          ),
      ],
    );
  }

  int _calculateDuration() {
    if (workout.startTime == null || workout.endTime == null) return 0;
    return workout.endTime!.difference(workout.startTime!).inMinutes;
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[month - 1];
  }

  String _getDayOfWeekAbbreviation(int weekday) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[weekday - 1];
  }

  void _deleteWorkout(BuildContext context, int workoutId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: const Text(
            'Are you sure you want to delete this workout? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context.read<WorkoutDao>().deleteWorkout(workoutId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                success > 0 ? 'Workout deleted' : 'Failed to delete workout'),
            backgroundColor: success > 0 ? Colors.green : Colors.red,
          ),
        );

        // Refresh list after deletion
        context.read<WorkoutLogModel>().loadWorkouts(refresh: true);
      }
    }
  }
}
