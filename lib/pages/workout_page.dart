import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// TODO: Import your exercise models/services here
// TODO: Import your workout state management here
import '../widgets/workout/workout_header.dart';
import '../widgets/workout/exercise_card.dart';
import '../widgets/workout/exercise_selector_sheet.dart';
import '../widgets/dialogs/exit_confirmation_dialog.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final ScrollController _scrollController = ScrollController();
  
  // TODO: Replace with your workout state management
  // Example: List<WorkoutExercise> exercises = [];
  // Example: Or use a provider/bloc/riverpod state management solution

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    // Use a small delay to ensure the UI has updated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _addExercise() async {
    await ExerciseSelectorSheet.show(context);
    // Auto-scroll to bottom after adding exercise
    _scrollToBottom();
  }

  Future<void> _finishWorkout() async {
    // TODO: Implement workout saving logic
    // Example:
    // final workout = Workout(
    //   date: DateTime.now(),
    //   exercises: exercises,
    // );
    // await database.workoutDao.createWorkout(workout);
    
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with your state management solution
    // Example: final exerciseModel = context.watch<ExerciseModel>();
    // Example: final exercises = context.watch<WorkoutNotifier>().exercises;
    final exercises = <dynamic>[]; // Placeholder - replace with your exercise list
    
    // TODO: Replace with your loading state logic
    final isLoaded = true; // exerciseModel?.isLoaded ?? true;

    if (!isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: false, // Prevent immediate popping
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await ExitConfirmationDialog.show(context);
          if (shouldExit && context.mounted) {
            Navigator.of(context).pop(true);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "New Workout",
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // const WorkoutHeader(),
              const Divider(height: 20),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: exercises.length + 1, // +1 for the Add Exercise button
                  itemBuilder: (context, index) {
                    // If we're at the last index, show the Add Exercise button
                    if (index == exercises.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton.icon(
                          onPressed: _addExercise,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Exercise"),
                        ),
                      );
                    }

                    // Otherwise, show the exercise card
                    return ExerciseCard(
                      exerciseIndex: index,
                      exercise: exercises[index],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _finishWorkout,
                child: const Text("Finish Workout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}