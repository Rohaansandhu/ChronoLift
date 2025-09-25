import 'package:flutter/material.dart';
import 'package:chronolift/database/database.dart';
import 'package:chronolift/database/dao/workout_dao.dart';
import 'package:chronolift/database/dao/workout_exercise_dao.dart';
import 'package:chronolift/database/dao/workout_set_dao.dart';

// Represents detailed workout data
class WorkoutDetail {
  final Workout workout;
  final List<WorkoutExerciseWithSets> exercises;
  final WorkoutStats stats;

  WorkoutDetail({
    required this.workout,
    required this.exercises,
    required this.stats,
  });
}

class WorkoutLogModel extends ChangeNotifier {
  final WorkoutDao _workoutDao;
  final WorkoutExerciseDao _workoutExerciseDao;
  final WorkoutSetDao _workoutSetDao;

  List<Workout> _workouts = [];
  final Map<int, WorkoutDetail> _workoutDetailsCache = {};
  bool _isLoading = false;

  // Getters
  List<Workout> get workouts => _workouts;
  bool get isLoading => _isLoading;

  WorkoutLogModel(
    this._workoutDao,
    this._workoutExerciseDao,
    this._workoutSetDao,
  ) {
    loadWorkouts();
  }

  Future<void> loadWorkouts({bool refresh = false}) async {
  if (_isLoading) return;

  _isLoading = true;
  notifyListeners();

  try {
    // load all workouts from the database
    _workouts = await _workoutDao.getAllWorkouts();

  } catch (e) {
    debugPrint('Error loading workouts: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // Get detailed workout data
  Future<WorkoutDetail?> getWorkoutDetail(int workoutId) async {
    // Check cache first
    if (_workoutDetailsCache.containsKey(workoutId)) {
      return _workoutDetailsCache[workoutId];
    }

    try {
      final workoutData = await _workoutDao.getWorkoutWithExercises(workoutId);
      if (workoutData == null) return null;

      final stats = await _workoutDao.getWorkoutStats(workoutId);

      final detail = WorkoutDetail(
        workout: workoutData.workout,
        exercises: workoutData.exercises,
        stats: stats,
      );

      // Cache the result
      _workoutDetailsCache[workoutId] = detail;

      return detail;
    } catch (e) {
      debugPrint('Error getting workout detail: $e');
      return null;
    }
  }

  // Delete workout
  Future<bool> deleteWorkout(int workoutId) async {
    try {
      await _workoutDao.deleteWorkout(workoutId);

      // Remove from list
      _workouts.removeWhere((w) => w.id == workoutId);

      // Clear from cache
      _workoutDetailsCache.remove(workoutId);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting workout: $e');
      return false;
    }
  }
}
