import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise_model.dart';
import '../models/workout_state.dart';
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

  @override
  Widget build(BuildContext context) {
    final exerciseModel = context.watch<ExerciseModel>();
    final workoutState = context.watch<WorkoutState>();

    if (!exerciseModel.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: false, // Prevent immediate popping
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await ExitConfirmationDialog.show(context);
          if (shouldExit && context.mounted) {
            Navigator.of(context).pop(true); // you can pass a result if needed
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
              const WorkoutHeader(),
              const Divider(height: 20),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: workoutState.exercises.length + 1, // +1 for the Add Exercise button
                  itemBuilder: (context, index) {
                    // If we're at the last index, show the Add Exercise button
                    if (index == workoutState.exercises.length) {
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
                      exercise: workoutState.exercises[index],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => workoutState.finishWorkout(context),
                child: const Text("Finish Workout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}