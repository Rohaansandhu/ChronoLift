import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'workout_log_model.dart';

/// Workout state manager
class WorkoutState extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final DateTime startTime = DateTime.now();
  DateTime? endTime;

  String? selectedRoutine;
  final List<Map<String, dynamic>> exercises = [];
  
  // Track which field is being edited (exerciseIndex_setIndex_fieldType)
  String? _editingField;
  String? get editingField => _editingField;

  void setEditingField(String? fieldId) {
    _editingField = fieldId;
    notifyListeners();
  }

  bool isFieldEditing(int exerciseIndex, int setIndex, String fieldType) {
    return _editingField == "${exerciseIndex}_${setIndex}_$fieldType";
  }

  void addExercise(String name) {
    exercises.add({"name": name, "sets": []});
    notifyListeners();
  }

  void addSet(int index, int reps, double weight, String notes) {
    exercises[index]["sets"].add({"reps": reps, "weight": weight, "notes": notes});
    notifyListeners();
  }

  void updateSet(int exerciseIndex, int setIndex, int reps, double weight, String notes) {
    exercises[exerciseIndex]["sets"][setIndex] = {"reps": reps, "weight": weight, "notes": notes};
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

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}