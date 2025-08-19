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

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  Future<void> _addExerciseDialog(BuildContext context) async {
    final exerciseModel = context.read<ExerciseModel>();
    final workoutState = context.read<WorkoutState>();
    String? chosenCategory;
    String? chosenExercise;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Choose Exercise"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    hint: const Text("Select Category"),
                    value: chosenCategory,
                    items: exerciseModel.categories.keys
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        chosenCategory = val;
                        chosenExercise = null;
                      });
                    },
                  ),
                  if (chosenCategory != null)
                    DropdownButton<String>(
                      hint: const Text("Select Exercise"),
                      value: chosenExercise,
                      items: (exerciseModel.categories[chosenCategory]!
                              as List<dynamic>)
                          .map((ex) => DropdownMenuItem<String>(
                                value: ex.toString(),
                                child: Text(ex.toString()),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setDialogState(() => chosenExercise = val);
                      },
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: chosenExercise == null
                      ? null
                      : () {
                          workoutState.addExercise(chosenExercise!);
                          Navigator.pop(context);
                        },
                  child: const Text("Add"),
                )
              ],
            );
          },
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    final exerciseModel = context.watch<ExerciseModel>();
    final workoutState = context.watch<WorkoutState>();

    if (!exerciseModel.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("New Workout")),
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
                itemCount: workoutState.exercises.length,
                itemBuilder: (context, index) {
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
            ElevatedButton.icon(
              onPressed: () => _addExerciseDialog(context),
              icon: const Icon(Icons.add),
              label: const Text("Add Exercise"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => workoutState.finishWorkout(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Finish Workout"),
            ),
          ],
        ),
      ),
    );
  }
}
