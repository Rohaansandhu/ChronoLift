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
  bool _hasActiveWorkout = false;

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
  bool get hasActiveWorkout => _hasActiveWorkout;
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
      _hasActiveWorkout = true;
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
        _name = workoutData.workout.name;
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

      // Persist the new order to the database
      await _updateExerciseOrder();

      notifyListeners();
    } catch (e) {
      debugPrint('Error removing exercise: $e');
    }
  }

// Update exercise order in database
  Future<void> _updateExerciseOrder() async {
    try {
      for (final exercise in _exercises) {
        await _workoutExerciseDao.updateWorkoutExercise(
          exercise.workoutExerciseId,
          WorkoutExercisesCompanion(
            orderInWorkout: Value(exercise.orderInWorkout),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error updating exercise order: $e');
    }
  }

  // Add set to exercise
  Future<void> addSet(WorkoutExerciseState exercise,
      {WorkoutSetState? copyFrom}) async {
    final setNumber = exercise.sets.length + 1;

    try {
      // Create the new set and save it to the database immediately
      final setId = await _workoutSetDao.addSet(
        workoutExerciseId: exercise.workoutExerciseId,
        setNumber: setNumber,
        weight: copyFrom?.weight,
        reps: copyFrom?.reps,
        duration: copyFrom?.duration,
        rpe: copyFrom?.rpe,
        notes: copyFrom?.notes,
        isWarmup: copyFrom?.isWarmup ?? false,
      );

      // Create the set state with the database ID
      final newSet = WorkoutSetState(
        id: setId, // Now has a database ID
        setNumber: setNumber,
        weight: copyFrom?.weight,
        reps: copyFrom?.reps,
        duration: copyFrom?.duration,
        rpe: copyFrom?.rpe,
        notes: copyFrom?.notes,
        isWarmup: copyFrom?.isWarmup ?? false,
        isCompleted: true, // Mark as completed since it's saved
        isEditing: false, // Not in editing mode by default
      );

      exercise.sets.add(newSet);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding set: $e');
    }
  }

  // Update set
  Future<void> updateSet(
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
  }) async {
    if (exerciseIndex < 0 || exerciseIndex >= _exercises.length) return;
    final exercise = _exercises[exerciseIndex];

    if (setIndex < 0 || setIndex >= exercise.sets.length) return;
    final set = exercise.sets[setIndex];

    // Update the local state first
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

    // If the set has an ID (is saved), update it in the database
    if (set.id != null) {
      try {
        await _workoutSetDao.updateSet(
          set.id!,
          SetsCompanion(
            weight: Value(exercise.sets[setIndex].weight),
            reps: Value(exercise.sets[setIndex].reps),
            duration: Value(exercise.sets[setIndex].duration),
            rpe: Value(exercise.sets[setIndex].rpe),
            notes: Value(exercise.sets[setIndex].notes),
            isWarmup: Value(exercise.sets[setIndex].isWarmup),
          ),
        );
      } catch (e) {
        debugPrint('Error updating set: $e');
      }
    }

    notifyListeners();
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

      // Renumber remaining sets in memory
      for (int i = setIndex; i < exercise.sets.length; i++) {
        exercise.sets[i] = exercise.sets[i].copyWith(setNumber: i + 1);
      }

      // Persist the new set numbers to the database
      await _updateSetOrder(exercise);

      notifyListeners();
    } catch (e) {
      debugPrint('Error removing set: $e');
    }
  }

// Update set order in database
  Future<void> _updateSetOrder(WorkoutExerciseState exercise) async {
    try {
      for (final set in exercise.sets) {
        if (set.id != null) {
          await _workoutSetDao.updateSet(
            set.id!,
            SetsCompanion(
              setNumber: Value(set.setNumber),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error updating set order: $e');
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

// Update workout start time
  Future<void> updateStartTime(DateTime startTime) async {
    _startTime = startTime;

    // Update the database if we have a current workout
    if (_currentWorkout != null) {
      try {
        await _workoutDao.updateWorkout(
          _currentWorkout!.id,
          WorkoutsCompanion(
            startTime: Value(startTime),
          ),
        );
      } catch (e) {
        debugPrint('Error updating start time: $e');
      }
    }

    // Restart the duration timer with the new start time
    if (_endTime == null) {
      _startDurationTimer();
    }

    notifyListeners();
  }

// Update workout end time
  Future<void> updateEndTime(DateTime? endTime) async {
    _endTime = endTime;

    // Update the database if we have a current workout
    if (_currentWorkout != null) {
      try {
        await _workoutDao.updateWorkout(
          _currentWorkout!.id,
          WorkoutsCompanion(
            endTime: Value(endTime),
          ),
        );
      } catch (e) {
        debugPrint('Error updating end time: $e');
      }
    }

    // Stop/start duration timer based on end time
    if (endTime != null) {
      _durationTimer?.cancel();
    } else if (_startTime != null) {
      _startDurationTimer();
    }

    notifyListeners();
  }

  // Finish workout
  Future<bool> finishWorkout(BuildContext context) async {
    if (_currentWorkout == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      if (_hasActiveWorkout) {
        _endTime = DateTime.now();
      }

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
      _hasActiveWorkout = false;

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
      if (context.mounted) {
        Navigator.pop(context);
      }
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
      _hasActiveWorkout = false;

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
