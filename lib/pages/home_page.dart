import 'package:chronolift/database/dao/workout_dao.dart';
import 'package:chronolift/services/global_user_service.dart';
import 'package:chronolift/widgets/home/workout_log_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chronolift/models/workout_log_model.dart';
import 'package:chronolift/models/workout_state.dart';
import 'workout_page.dart';
import 'package:shiny_button/shiny_button.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<WorkoutLogModel>().loadMore();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutLogModel>().loadWorkouts(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ChronoLift - Workout Log",
          style: TextStyle(color: colorScheme.tertiary),
        ),
        backgroundColor: colorScheme.primary,
      ),
      backgroundColor: colorScheme.surface,
      body: Consumer<WorkoutStateModel>(
        builder: (context, workoutState, child) {
          if (workoutState.hasActiveWorkout) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: colorScheme.primaryContainer,
                  child: Row(
                    children: [
                      Icon(Icons.fitness_center,
                          color: colorScheme.onPrimaryContainer),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Workout in Progress',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              _formatDuration(workoutState.elapsedDuration),
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onPrimaryContainer
                                    .withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WorkoutPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildWorkoutList(context)),
              ],
            );
          }

          return Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 80,
                width: 275,
                child: ShinyButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkoutPage()),
                    );
                  },
                  label: 'New Workout',
                  icon: const Icon(Icons.add, color: Colors.black),
                  backgroundColor: const Color(0xFFFFD6A5),
                  textColor: Colors.black87,
                  shineDirection: ShineDirection.leftToRight,
                  iconPosition: IconPosition.leading,
                  tooltip: 'Start a new workout',
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  borderRadius: 16.0,
                  elevation: 4.0,
                  shadowColor: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildWorkoutList(context)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWorkoutList(BuildContext context) {
    return Consumer<WorkoutLogModel>(
      builder: (context, workoutLog, child) {
        if (workoutLog.isLoading && workoutLog.workouts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (workoutLog.workouts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center,
                    size: 64,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(
                  "No Workouts Yet",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Start your first workout to see it here!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => workoutLog.loadWorkouts(refresh: true),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount:
                workoutLog.workouts.length,
            itemBuilder: (context, index) {
              if (index == workoutLog.workouts.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final workout = workoutLog.workouts[index];

              return FutureBuilder<WorkoutWithExercises?>(
                future: context
                    .read<WorkoutDao>()
                    .getWorkoutWithExercises(workout.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // or SizedBox.shrink() if you want empty space
                  } else if (snapshot.hasError) {
                    return Text("Error loading workout: ${snapshot.error}");
                  } else if (!snapshot.hasData) {
                    return const Text("No data found");
                  }

                  final workoutWithExercises = snapshot.data!;
                  return WorkoutLogCard(
                    workout: workoutWithExercises.workout,
                    exercises: workoutWithExercises.exercises,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  void _showWorkoutDetails(BuildContext context, int workoutId) {
    // Navigate to workout detail page if needed
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
      final success =
          await context.read<WorkoutLogModel>().deleteWorkout(workoutId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(success ? 'Workout deleted' : 'Failed to delete workout'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}
