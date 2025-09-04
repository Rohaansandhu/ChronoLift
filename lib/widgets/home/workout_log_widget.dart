import 'package:flutter/material.dart';

class WorkoutLogCard extends StatelessWidget {
  final Map<String, dynamic> workoutLog;

  const WorkoutLogCard({
    super.key,
    required this.workoutLog,
  });

  @override
  Widget build(BuildContext context) {
    // Parse workout data
    final DateTime workoutDate = (workoutLog['date']).toDate();
    final String workoutName = workoutLog['name'] ?? 'Unnamed Workout';
    final int durationMinutes = _calculateDuration();
    final List<String> exerciseNames = _extractExerciseNames();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            // Calendar Icon with Date
            _buildCalendarSection(workoutDate),

            const SizedBox(width: 16),

            // Workout Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Workout Name and Duration Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          workoutName,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
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
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Exercise List
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
        color: const Color(0xFFFFD6A5).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFFD6A5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 20,
            color: Colors.grey[700],
          ),
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
            style: const TextStyle(
              fontSize: 9,
              color: Colors.grey,
            ),
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

    // Show up to 4 exercises, then "and X more"
    const int maxVisible = 4;
    final List<String> visibleExercises =
        exerciseNames.take(maxVisible).toList();
    final int remainingCount = exerciseNames.length - maxVisible;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...visibleExercises.map((exercise) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                exercise,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                    ),
              ),
            )),
        if (remainingCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
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

  //TODO: Add duration calculation in workout page
  int _calculateDuration() {
    // Calculate from start/end time
    final DateTime startTime = (workoutLog['startTime']).toDate();
    final DateTime endTime = (workoutLog['endTime']).toDate();

    return endTime.difference(startTime).inMinutes;
  }

  List<String> _extractExerciseNames() {
    final List<String> exerciseNames = [];

    // Try different possible structures for exercises
    final dynamic exercises = workoutLog['exercises'] ??
        workoutLog['exerciseList'] ??
        workoutLog['workoutExercises'];

    if (exercises == null) return exerciseNames;

    if (exercises is List) {
      for (final exercise in exercises) {
        if (exercise is Map<String, dynamic>) {
          final String name = exercise['name'] ??
              exercise['exerciseName'] ??
              exercise['title'] ??
              'Unknown Exercise';
          if (!exerciseNames.contains(name)) {
            exerciseNames.add(name);
          }
        } else if (exercise is String) {
          if (!exerciseNames.contains(exercise)) {
            exerciseNames.add(exercise);
          }
        }
      }
    } else if (exercises is Map<String, dynamic>) {
      // Handle case where exercises is a map with exercise IDs as keys
      for (final exerciseData in exercises.values) {
        if (exerciseData is Map<String, dynamic>) {
          final String name = exerciseData['name'] ??
              exerciseData['exerciseName'] ??
              'Unknown Exercise';
          if (!exerciseNames.contains(name)) {
            exerciseNames.add(name);
          }
        }
      }
    }

    return exerciseNames;
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
}
