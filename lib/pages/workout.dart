import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final TextEditingController _nameController = TextEditingController();
  DateTime startTime = DateTime.now();
  DateTime? endTime;

  String? selectedRoutine;
  List<Map<String, dynamic>> exercises = [];

  // Example categories + exercises (replace later with your default lists)
  final Map<String, List<String>> exerciseCategories = {
    "Chest": ["Bench Press", "Incline Dumbbell Press", "Push Ups"],
    "Legs": ["Squat", "Lunge", "Leg Press"],
    "Biceps": ["Barbell Curl", "Hammer Curl"],
    "Triceps": ["Tricep Dips", "Overhead Extension"],
  };

  // Add exercise dialog
  Future<void> _addExerciseDialog() async {
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
                    items: exerciseCategories.keys
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        chosenCategory = val;
                        chosenExercise = null; // reset on category change
                      });
                    },
                  ),
                  if (chosenCategory != null)
                    DropdownButton<String>(
                      hint: const Text("Select Exercise"),
                      value: chosenExercise,
                      items: exerciseCategories[chosenCategory]!
                          .map((ex) => DropdownMenuItem(
                                value: ex,
                                child: Text(ex),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setDialogState(() {
                          chosenExercise = val;
                        });
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
                          setState(() {
                            exercises.add({
                              "name": chosenExercise!,
                              "sets": [],
                            });
                          });
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

  // Add set to exercise
  void _addSet(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final repsController = TextEditingController();
        final weightController = TextEditingController();
        return AlertDialog(
          title: Text("Add Set - ${exercises[index]['name']}"),
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
                setState(() {
                  exercises[index]["sets"].add({
                    "reps": int.tryParse(repsController.text) ?? 0,
                    "weight": double.tryParse(weightController.text) ?? 0,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Save workout to Firestore
  Future<void> _finishWorkout() async {
    endTime = DateTime.now();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("workouts")
        .doc(user.uid)
        .collection("userWorkouts")
        .add({
      "name": _nameController.text.isEmpty
          ? "Workout"
          : _nameController.text.trim(),
      "startTime": startTime,
      "endTime": endTime,
      "date": DateTime.now(),
      "routine": selectedRoutine,
      "exercises": exercises,
    });

    Navigator.pop(context); // Go back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Workout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Workout Name"),
            ),
            const SizedBox(height: 10),
            Text("Start: ${startTime.toLocal()}"),
            if (endTime != null) Text("End: ${endTime!.toLocal()}"),
            const SizedBox(height: 10),

            // Routine dropdown
            DropdownButton<String>(
              hint: const Text("Select Routine (optional)"),
              value: selectedRoutine,
              items: ["Push", "Pull", "Legs"]
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedRoutine = val;
                });
              },
            ),

            const Divider(height: 20),

            // Exercise list
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return Card(
                    child: ListTile(
                      title: Text(exercise["name"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...(exercise["sets"] as List).map((set) => Text(
                              "Reps: ${set['reps']} | Weight: ${set['weight']}kg")),
                          TextButton(
                            onPressed: () => _addSet(index),
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
              onPressed: _addExerciseDialog,
              icon: const Icon(Icons.add),
              label: const Text("Add Exercise"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _finishWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text("Finish Workout"),
            ),
          ],
        ),
      ),
    );
  }
}
