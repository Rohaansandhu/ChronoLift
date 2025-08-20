import 'package:chronolift/models/workout_log_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '/models/exercise_model.dart';

/// Workout state manager
class WorkoutState extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final DateTime startTime = DateTime.now();
  DateTime? endTime;

  String? selectedRoutine;
  final List<Map<String, dynamic>> exercises = [];

  void addExercise(String name) {
    exercises.add({"name": name, "sets": []});
    notifyListeners();
  }

  void addSet(int index, int reps, double weight) {
    exercises[index]["sets"].add({"reps": reps, "weight": weight});
    notifyListeners();
  }

  Future<void> finishWorkout(BuildContext context) async {
    endTime = DateTime.now();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("workouts")
        .add({
      "name":
          nameController.text.isEmpty ? "Workout" : nameController.text.trim(),
      "startTime": startTime,
      "endTime": endTime,
      "date": DateTime.now(),
      "routine": selectedRoutine,
      "exercises": exercises,
    });

    // Refresh the workout logs on the home page
    if (context.mounted) {
      // Get the WorkoutLogModel from the root of the widget tree
      final workoutLogModel = Provider.of<WorkoutLogModel>(context, listen: false);
      await workoutLogModel.refreshLogs();
    }

    Navigator.pop(context);
  }
}

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

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

  Future<void> _addExerciseBottomSheet(BuildContext context) async {
    final exerciseModel = context.read<ExerciseModel>();
    final workoutState = context.read<WorkoutState>();
    final theme = Theme.of(context);

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
              itemCount: exerciseModel.categories.keys.length + 1,
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
                final cat = exerciseModel.categories.keys.elementAt(index - 1);
                return ListTile(
                  title: Text(
                    cat,
                    style: theme.textTheme.bodyLarge,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: theme.colorScheme.tertiary),
                  onTap: () => Navigator.pop(context, cat),
                );
              },
            );
          },
        );
      },
    );

    if (chosenCategory == null) return;

    // Step 2: Exercise bottom sheet
    final chosenExercise = await showModalBottomSheet<String>(
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
            final exercises = exerciseModel.categories[chosenCategory]!;

            return ListView.separated(
              controller: scrollController,
              itemCount: exercises.length + 1,
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
                      "Select Exercise From $chosenCategory",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                final ex = exercises[index - 1].toString();
                return ListTile(
                  title: Text(
                    ex,
                    style: theme.textTheme.bodyLarge,
                  ),
                  onTap: () => Navigator.pop(context, ex),
                );
              },
            );
          },
        );
      },
    );

    if (chosenExercise != null) {
      workoutState.addExercise(chosenExercise);
      // Auto-scroll to bottom after adding exercise
      _scrollToBottom();
    }
  }

  void _addSetDialog(BuildContext context, int index) {
    final workoutState = context.read<WorkoutState>();
    final repsController = TextEditingController();
    final weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Set - ${workoutState.exercises[index]['name']}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Reps"),
              ),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Weight (kg)"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                workoutState.addSet(
                  index,
                  int.tryParse(repsController.text) ?? 0,
                  double.tryParse(weightController.text) ?? 0,
                );
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showExitConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit Workout?"),
          content: const Text(
            "Are you sure you want to exit? Your workout progress will be lost.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
    return result ?? false; // Default to false if dialog is dismissed
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
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldExit = await _showExitConfirmation();
          if (shouldExit && context.mounted) {
            Navigator.of(context).pop();
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
            TextField(
              controller: workoutState.nameController,
              decoration: const InputDecoration(labelText: "Workout Name"),
            ),
            const SizedBox(height: 10),
            Text("Start: ${workoutState.startTime.toLocal()}"),
            if (workoutState.endTime != null)
              Text("End: ${workoutState.endTime!.toLocal()}"),
            const SizedBox(height: 10),
            DropdownButton<String>(
              hint: const Text("Select Routine (optional)"),
              value: workoutState.selectedRoutine,
              items: ["Push", "Pull", "Legs"]
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (val) {
                workoutState.selectedRoutine = val;
                workoutState.notifyListeners();
              },
            ),
            const Divider(height: 20),
            Expanded(
              child: ListView.builder(
                controller: _scrollController, // Added scroll controller
                itemCount: workoutState.exercises.length + 1, // +1 for the Add Exercise button
                itemBuilder: (context, index) {
                  // If we're at the last index, show the Add Exercise button
                  if (index == workoutState.exercises.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: () => _addExerciseBottomSheet(context),
                        icon: const Icon(Icons.add),
                        label: const Text("Add Exercise"),
                      ),
                    );
                  }

                  // Otherwise, show the exercise card
                  final exercise = workoutState.exercises[index];
                  return Card(
                    child: ListTile(
                      title: Text(exercise["name"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...(exercise["sets"] as List).map((set) => Text(
                              "Reps: ${set['reps']} | Weight: ${set['weight']}kg")),
                          TextButton(
                            onPressed: () => _addSetDialog(context, index),
                            child: const Text("Add Set"),
                          )
                        ],
                      ),
                    ),
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
    ));
  }
}