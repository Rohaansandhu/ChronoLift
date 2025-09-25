import 'package:chronolift/services/global_user_service.dart';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/workouts_table.dart';
import '../tables/exercises_table.dart';
import '../tables/workout_exercises_table.dart';
import '../tables/workout_sets_table.dart';

part 'workout_dao.g.dart';

@DriftAccessor(tables: [Workouts, Exercises, WorkoutExercises, Sets])
class WorkoutDao extends DatabaseAccessor<AppDatabase> with _$WorkoutDaoMixin {
  WorkoutDao(super.db);

  // Create a new workout
  Future<int> createWorkout(WorkoutsCompanion workout) async {
    return await into(workouts).insert(workout);
  }

  // Get all workouts
  Future<List<Workout>> getAllWorkouts() async {
    return await (select(workouts)..orderBy([(w) => OrderingTerm.desc(w.date)]))
        .get();
  }

  // Get workout by ID with exercises and sets
  Future<WorkoutWithExercises?> getWorkoutWithExercises(int workoutId) async {
    final query = select(workouts).join([
      leftOuterJoin(
          workoutExercises, workoutExercises.workoutId.equalsExp(workouts.id)),
      leftOuterJoin(
          exercises, exercises.id.equalsExp(workoutExercises.exerciseId)),
      leftOuterJoin(
          sets, sets.workoutExerciseId.equalsExp(workoutExercises.id)),
    ])
      ..where(workouts.id.equals(workoutId));

    final rows = await query.get();
    if (rows.isEmpty) return null;

    final workout = rows.first.readTable(workouts);
    final exerciseMap = <int, WorkoutExerciseWithSets>{};

    for (final row in rows) {
      final workoutExercise = row.readTableOrNull(workoutExercises);
      final exercise = row.readTableOrNull(exercises);
      final set = row.readTableOrNull(sets);

      if (workoutExercise != null && exercise != null) {
        if (!exerciseMap.containsKey(workoutExercise.id)) {
          exerciseMap[workoutExercise.id] = WorkoutExerciseWithSets(
            workoutExercise: workoutExercise,
            exercise: exercise,
            sets: [],
          );
        }

        if (set != null) {
          exerciseMap[workoutExercise.id]!.sets.add(set);
        }
      }
    }

    return WorkoutWithExercises(
      workout: workout,
      exercises: exerciseMap.values.toList(),
    );
  }

  // Update workout
  Future<int> updateWorkout(int id, WorkoutsCompanion workout) async {
    return await (update(workouts)..where((w) => w.id.equals(id)))
        .write(workout);
  }

  // Delete workout
  Future<int> deleteWorkout(int id) async {
    return await (delete(workouts)..where((w) => w.id.equals(id))).go();
  }

  // Add exercise to workout
  Future<int> addExerciseToWorkout({
    required int workoutId,
    required int exerciseId,
    required int order,
    String? notes,
  }) async {
    final uuid = globalUser.currentUserUuid!;
    return await into(workoutExercises).insert(
      WorkoutExercisesCompanion.insert(
          workoutId: workoutId,
          exerciseId: exerciseId,
          orderInWorkout: order,
          notes: Value(notes),
          uuid: uuid),
    );
  }

  // Add set to exercise
  Future<int> addSet({
    required int workoutExerciseId,
    required int setNumber,
    double? weight,
    int? reps,
    int? duration,
    int? rpe,
  }) async {
    final uuid = globalUser.currentUserUuid!;
    return await into(sets).insert(
      SetsCompanion.insert(
        workoutExerciseId: workoutExerciseId,
        setNumber: setNumber,
        weight: Value(weight),
        reps: Value(reps),
        duration: Value(duration),
        rpe: Value(rpe),
        uuid: uuid
      ),
    );
  }

  // Get workout stats
  Future<WorkoutStats> getWorkoutStats(int workoutId) async {
    final totalSets = await (selectOnly(sets)
          ..addColumns([sets.id.count()])
          ..join([
            innerJoin(workoutExercises,
                workoutExercises.id.equalsExp(sets.workoutExerciseId))
          ])
          ..where(workoutExercises.workoutId.equals(workoutId)))
        .getSingle();

    final totalVolume = await (selectOnly(sets)
          ..addColumns([(sets.weight * sets.reps.cast<double>()).sum()])
          ..join([
            innerJoin(workoutExercises,
                workoutExercises.id.equalsExp(sets.workoutExerciseId))
          ])
          ..where(workoutExercises.workoutId.equals(workoutId)))
        .getSingle();

    return WorkoutStats(
      totalSets: totalSets.read(sets.id.count()) ?? 0,
      totalVolume:
          totalVolume.read((sets.weight * sets.reps.cast<double>()).sum()) ??
              0.0,
    );
  }
}

// Helper classes
class WorkoutWithExercises {
  final Workout workout;
  final List<WorkoutExerciseWithSets> exercises;

  WorkoutWithExercises({required this.workout, required this.exercises});
}

class WorkoutExerciseWithSets {
  final WorkoutExercise workoutExercise;
  final Exercise exercise;
  final List<WorkoutSet> sets;

  WorkoutExerciseWithSets({
    required this.workoutExercise,
    required this.exercise,
    required this.sets,
  });
}

class WorkoutStats {
  final int totalSets;
  final double totalVolume;

  WorkoutStats({
    required this.totalSets,
    required this.totalVolume,
  });
}
