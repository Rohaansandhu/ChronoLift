import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise_model.dart';
import '../models/workout_state.dart';
import '../widgets/workout/workout_header.dart';
import '../widgets/workout/exercise_card.dart';
import '../widgets/workout/exercise_selector_sheet.dart';
import '../widgets/dialogs/exit_confirmation_dialog.dart';

class WorkoutPage extends StatefulWidget {
  final int? workoutId; // null for new workout, Id for editing existing

  const WorkoutPage({super.key, this.workoutId});

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

  @override
  void initState() {
    super.initState();

    // Load existing workout if editing
    if (widget.workoutId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<WorkoutStateModel>().loadWorkout(widget.workoutId!);
      });
    }
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
    final workoutState = context.read<WorkoutStateModel>();

    await ExerciseSelectorSheet.show(
      context,
      onExerciseSelected: (exercise) async {
        // Add the selected exercise to the workout state
        await workoutState.addExercise(exercise);
      },
    );

    // Auto-scroll to bottom after adding exercise
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseModel = context.watch<ExerciseModel>();
    final workoutState = context.watch<WorkoutStateModel>();

    if (exerciseModel.isLoading || workoutState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: false, // Prevent immediate popping
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              widget.workoutId != null ? "Edit Workout" : "New Workout",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.black),
                  onPressed: () async {
                    final result = await DeleteConfirmationDialog.show(context);
                    if (result == true && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ]),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const WorkoutHeader(),
              // show exercise list + finish button
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: workoutState.exercises.length + 1,
                  itemBuilder: (context, index) {
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
                    return ExerciseCard(exerciseIndex: index);
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
