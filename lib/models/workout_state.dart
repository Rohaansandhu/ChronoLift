import 'dart:async';

import 'package:chronolift/models/workout_log_model.dart';
import 'package:flutter/material.dart';
import 'package:chronolift/database/database.dart';
import 'package:chronolift/database/dao/workout_dao.dart';
import 'package:chronolift/database/dao/workout_exercise_dao.dart';
import 'package:chronolift/database/dao/workout_set_dao.dart';
import 'package:chronolift/services/global_user_service.dart';
import 'package:drift/drift.dart';
import 'package:provider/provider.dart';

// Represents an exercise in the current workout with its sets
class WorkoutExerciseState {
  final int workoutExerciseId;
  final Exercise exercise;
  final List<WorkoutSetState> sets;
  String? notes;
  int orderInWorkout;
  bool isExpanded;

  WorkoutExerciseState({
    required this.workoutExerciseId,
    required this.exercise,
    required this.orderInWorkout,
    this.notes,
    List<WorkoutSetState>? sets,
    this.isExpanded = true,
  }) : sets = sets ?? [];
}

// Represents a set in the current workout
class WorkoutSetState {
  final int? id; // null for unsaved sets
  final int setNumber;
  double? weight;
  int? reps;
  int? duration;
  int? rpe;
  String? notes;
  bool isWarmup;
  bool isCompleted;
  bool isEditing;

  WorkoutSetState({
    this.id,
    required this.setNumber,
    this.weight,
    this.reps,
    this.duration,
    this.rpe,
    this.notes,
    this.isWarmup = false,
    this.isCompleted = false,
    this.isEditing = false,
  });

  WorkoutSetState copyWith({
    int? id,
    int? setNumber,
    double? weight,
    int? reps,
    int? duration,
    int? rpe,
    String? notes,
    bool? isWarmup,
    bool? isCompleted,
    bool? isEditing,
  }) {
    return WorkoutSetState(
      id: id ?? this.id,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      duration: duration ?? this.duration,
      rpe: rpe ?? this.rpe,
      notes: notes ?? this.notes,
      isWarmup: isWarmup ?? this.isWarmup,
      isCompleted: isCompleted ?? this.isCompleted,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

class WorkoutStateModel extends ChangeNotifier {
  final WorkoutDao _workoutDao;
  final WorkoutExerciseDao _workoutExerciseDao;
  final WorkoutSetDao _workoutSetDao;

  // Current workout state
  Workout? _currentWorkout;
  List<WorkoutExerciseState> _exercises = [];
  String? _name;
  DateTime? _startTime;
  DateTime? _endTime;
  String? _notes;
  bool _isLoading = false;
  bool _isSaving = false;
  Timer? _durationTimer;
  Duration _elapsedDuration = Duration.zero;

  // Rest timer
  Timer? _restTimer;
  Duration _restDuration = Duration.zero;
  Duration _targetRestDuration = const Duration(seconds: 90);
  bool _isResting = false;

  // Getters
  Workout? get currentWorkout => _currentWorkout;
  List<WorkoutExerciseState> get exercises => _exercises;
  String? get name => _name;
  DateTime? get startTime => _startTime;
  DateTime? get endTime => _endTime;
  String? get notes => _notes;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get hasActiveWorkout => _currentWorkout != null;
  Duration get elapsedDuration => _elapsedDuration;
  Duration get restDuration => _restDuration;
  Duration get targetRestDuration => _targetRestDuration;
  bool get isResting => _isResting;

  // Stats getters
  int get totalSets => _exercises.fold(0, (sum, e) => sum + e.sets.length);
  int get completedSets => _exercises.fold(
      0, (sum, e) => sum + e.sets.where((s) => s.isCompleted).length);
  double get totalVolume => _exercises.fold(
      0.0,
      (sum, e) =>
          sum +
          e.sets.fold(
              0.0, (setSum, s) => setSum + ((s.weight ?? 0) * (s.reps ?? 0))));

  WorkoutStateModel(
    this._workoutDao,
    this._workoutExerciseDao,
    this._workoutSetDao,
  );

  // Start a new workout
  Future<void> startWorkout({String? name, String? notes}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final globalUser = GlobalUserService.instance;
      final uuid = globalUser.currentUserUuid!;
      final workoutId = await _workoutDao.createWorkout(
        WorkoutsCompanion.insert(
          uuid: uuid,
          name: Value(name),
          date: DateTime.now(),
          notes: Value(notes),
          startTime: Value(DateTime.now()),
        ),
      );

      // Load the created workout
      final workouts = await _workoutDao.getAllWorkouts();
      _currentWorkout = workouts.firstWhere((w) => w.id == workoutId);
      _startTime = DateTime.now();
      _notes = notes;
      _exercises = [];

      // Start duration timer
      _startDurationTimer();
    } catch (e) {
      debugPrint('Error starting workout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load existing workout for editing
  Future<void> loadWorkout(int workoutId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final workoutData = await _workoutDao.getWorkoutWithExercises(workoutId);
      if (workoutData != null) {
        _currentWorkout = workoutData.workout;
        _startTime = workoutData.workout.startTime;
        _endTime = workoutData.workout.endTime;
        _notes = workoutData.workout.notes;

        // Convert to state objects
        _exercises = workoutData.exercises.map((e) {
          final sets = e.sets
              .map((s) => WorkoutSetState(
                    id: s.id,
                    setNumber: s.setNumber,
                    weight: s.weight,
                    reps: s.reps,
                    duration: s.duration,
                    rpe: s.rpe,
                    notes: s.notes,
                    isWarmup: s.isWarmup,
                    isCompleted: true, // Assume saved sets are completed
                  ))
              .toList();

          return WorkoutExerciseState(
            workoutExerciseId: e.workoutExercise.id,
            exercise: e.exercise,
            orderInWorkout: e.workoutExercise.orderInWorkout,
            notes: e.workoutExercise.notes,
            sets: sets,
          );
        }).toList();

        if (_endTime == null && _startTime != null) {
          _startDurationTimer();
        }
      }
    } catch (e) {
      debugPrint('Error loading workout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add exercise to workout
  Future<void> addExercise(Exercise exercise) async {
    if (_currentWorkout == null) return;

    try {
      final workoutExerciseId = await _workoutExerciseDao.addExerciseToWorkout(
        workoutId: _currentWorkout!.id,
        exerciseId: exercise.id,
      );

      final exerciseState = WorkoutExerciseState(
        workoutExerciseId: workoutExerciseId,
        exercise: exercise,
        orderInWorkout: _exercises.length + 1,
      );

      _exercises.add(exerciseState);

      // Auto-add first set
      await addSet(exerciseState);

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding exercise: $e');
    }
  }

  // Remove exercise from workout
  Future<void> removeExercise(int index) async {
    if (index < 0 || index >= _exercises.length) return;

    try {
      final exercise = _exercises[index];
      await _workoutExerciseDao
          .deleteWorkoutExercise(exercise.workoutExerciseId);
      _exercises.removeAt(index);

      // Reorder remaining exercises
      for (int i = index; i < _exercises.length; i++) {
        _exercises[i].orderInWorkout = i + 1;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error removing exercise: $e');
    }
  }

  // Add set to exercise
  Future<void> addSet(WorkoutExerciseState exercise,
      {WorkoutSetState? copyFrom}) async {
    final setNumber = exercise.sets.length + 1;
    final newSet = WorkoutSetState(
      setNumber: setNumber,
      weight: copyFrom?.weight,
      reps: copyFrom?.reps,
      duration: copyFrom?.duration,
      rpe: copyFrom?.rpe,
      isWarmup: copyFrom?.isWarmup ?? false,
      isEditing: true,
    );

    exercise.sets.add(newSet);
    notifyListeners();
  }

  // Update set
  void updateSet(
    int exerciseIndex,
    int setIndex, {
    double? weight,
    int? reps,
    int? duration,
    int? rpe,
    String? notes,
    bool? isWarmup,
    bool? isCompleted,
    bool? isEditing,
  }) {
    if (exerciseIndex < 0 || exerciseIndex >= _exercises.length) return;
    final exercise = _exercises[exerciseIndex];

    if (setIndex < 0 || setIndex >= exercise.sets.length) return;
    final set = exercise.sets[setIndex];

    exercise.sets[setIndex] = set.copyWith(
      weight: weight ?? set.weight,
      reps: reps ?? set.reps,
      duration: duration ?? set.duration,
      rpe: rpe ?? set.rpe,
      notes: notes ?? set.notes,
      isWarmup: isWarmup ?? set.isWarmup,
      isCompleted: isCompleted ?? set.isCompleted,
      isEditing: isEditing ?? set.isEditing,
    );

    notifyListeners();
  }

  // Complete set (save to database)
  Future<void> completeSet(int exerciseIndex, int setIndex) async {
    if (exerciseIndex < 0 || exerciseIndex >= _exercises.length) return;
    final exercise = _exercises[exerciseIndex];

    if (setIndex < 0 || setIndex >= exercise.sets.length) return;
    final set = exercise.sets[setIndex];

    try {
      if (set.id == null) {
        // Save new set
        final setId = await _workoutSetDao.addSet(
          workoutExerciseId: exercise.workoutExerciseId,
          setNumber: set.setNumber,
          weight: set.weight,
          reps: set.reps,
          duration: set.duration,
          rpe: set.rpe,
          notes: set.notes,
          isWarmup: set.isWarmup,
        );

        exercise.sets[setIndex] = set.copyWith(
          id: setId,
          isCompleted: true,
          isEditing: false,
        );
      } else {
        // Update existing set
        await _workoutSetDao.updateSet(
          set.id!,
          SetsCompanion(
            weight: Value(set.weight),
            reps: Value(set.reps),
            duration: Value(set.duration),
            rpe: Value(set.rpe),
            notes: Value(set.notes),
            isWarmup: Value(set.isWarmup),
          ),
        );

        exercise.sets[setIndex] = set.copyWith(
          isCompleted: true,
          isEditing: false,
        );
      }

      // TODO: Add UI for rest timer
      // Start rest timer
      // startRestTimer();

      notifyListeners();
    } catch (e) {
      debugPrint('Error completing set: $e');
    }
  }

  // Remove set
  Future<void> removeSet(int exerciseIndex, int setIndex) async {
    if (exerciseIndex < 0 || exerciseIndex >= _exercises.length) return;
    final exercise = _exercises[exerciseIndex];

    if (setIndex < 0 || setIndex >= exercise.sets.length) return;
    final set = exercise.sets[setIndex];

    try {
      if (set.id != null) {
        await _workoutSetDao.deleteSet(set.id!);
      }

      exercise.sets.removeAt(setIndex);

      // Renumber remaining sets
      for (int i = setIndex; i < exercise.sets.length; i++) {
        exercise.sets[i] = exercise.sets[i].copyWith(setNumber: i + 1);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error removing set: $e');
    }
  }

  // Toggle exercise expansion
  void toggleExerciseExpanded(int index) {
    if (index < 0 || index >= _exercises.length) return;
    _exercises[index].isExpanded = !_exercises[index].isExpanded;
    notifyListeners();
  }

  // Update workout name
  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  // Update workout notes
  void updateNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  // Finish workout
  Future<bool> finishWorkout(BuildContext context) async {
    if (_currentWorkout == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      _endTime = DateTime.now();

      await _workoutDao.updateWorkout(
        _currentWorkout!.id,
        WorkoutsCompanion(
          name: Value(_name),
          notes: Value(_notes),
          endTime: Value(_endTime),
        ),
      );

      // Stop timers
      _durationTimer?.cancel();
      // _restTimer?.cancel();

      // Clear state
      _currentWorkout = null;
      _name = null;
      _exercises = [];
      _startTime = null;
      _endTime = null;
      _notes = null;
      _elapsedDuration = Duration.zero;
      _restDuration = Duration.zero;
      _isResting = false;

      return true;
    } catch (e) {
      debugPrint('Error finishing workout: $e');
      return false;
    } finally {
      _isSaving = false;
      // Refresh the workout logs on the home page
      if (context.mounted) {
        // Get the WorkoutLogModel from the root of the widget tree
        final workoutLogModel =
            Provider.of<WorkoutLogModel>(context, listen: false);
        await workoutLogModel.loadWorkouts();
      }
      Navigator.pop(context);
      notifyListeners();
    }
  }

  // Cancel workout
  Future<void> cancelWorkout() async {
    if (_currentWorkout == null) return;

    try {
      // Delete the workout (cascades to exercises and sets)
      await _workoutDao.deleteWorkout(_currentWorkout!.id);

      // Stop timers
      _durationTimer?.cancel();
      _restTimer?.cancel();

      // Clear state
      _currentWorkout = null;
      _name = null;
      _exercises = [];
      _startTime = null;
      _endTime = null;
      _notes = null;
      _elapsedDuration = Duration.zero;
      _restDuration = Duration.zero;
      _isResting = false;

      notifyListeners();
    } catch (e) {
      debugPrint('Error canceling workout: $e');
    }
  }

  // Rest timer methods
  void startRestTimer() {
    _restTimer?.cancel();
    _restDuration = Duration.zero;
    _isResting = true;

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _restDuration = Duration(seconds: _restDuration.inSeconds + 1);
      notifyListeners();

      // Auto-stop after target duration
      if (_restDuration >= _targetRestDuration) {
        // Could add notification/sound here
      }
    });
  }

  void stopRestTimer() {
    _restTimer?.cancel();
    _restDuration = Duration.zero;
    _isResting = false;
    notifyListeners();
  }

  void setTargetRestDuration(Duration duration) {
    _targetRestDuration = duration;
    notifyListeners();
  }

  // Duration timer
  void _startDurationTimer() {
    _durationTimer?.cancel();

    if (_startTime != null) {
      _elapsedDuration = DateTime.now().difference(_startTime!);

      _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedDuration = DateTime.now().difference(_startTime!);
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }
}
