import 'package:chronolift/services/global_user_service.dart';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/workout_exercises_table.dart';
import '../tables/exercises_table.dart';
import '../tables/workout_sets_table.dart';

part 'workout_exercise_dao.g.dart';

@DriftAccessor(tables: [WorkoutExercises, Exercises, Sets])
class WorkoutExerciseDao extends DatabaseAccessor<AppDatabase> with _$WorkoutExerciseDaoMixin {
  WorkoutExerciseDao(AppDatabase db) : super(db);

  // Create a new workout exercise
  Future<int> createWorkoutExercise(WorkoutExercisesCompanion workoutExercise) async {
    return await into(workoutExercises).insert(workoutExercise);
  }

  // Add exercise to workout with proper ordering
  Future<int> addExerciseToWorkout({
    required int workoutId,
    required int exerciseId,
    int? orderInWorkout,
    String? notes,
  }) async {
    final uuid = globalUser.currentUserUuid!;
    
    // If no order specified, get the next order number
    int order = orderInWorkout ?? await getNextOrderForWorkout(workoutId);
    
    return await into(workoutExercises).insert(
      WorkoutExercisesCompanion.insert(
        workoutId: workoutId,
        exerciseId: exerciseId,
        orderInWorkout: order,
        notes: Value(notes),
        uuid: uuid,
      ),
    );
  }

  // Get all exercises for a specific workout
  Future<List<WorkoutExerciseWithDetails>> getWorkoutExercises(int workoutId) async {
    final query = select(workoutExercises).join([
      innerJoin(exercises, exercises.id.equalsExp(workoutExercises.exerciseId)),
    ])
      ..where(workoutExercises.workoutId.equals(workoutId))
      ..orderBy([OrderingTerm.asc(workoutExercises.orderInWorkout)]);

    final rows = await query.get();
    
    return rows.map((row) {
      final workoutExercise = row.readTable(workoutExercises);
      final exercise = row.readTable(exercises);
      
      return WorkoutExerciseWithDetails(
        workoutExercise: workoutExercise,
        exercise: exercise,
      );
    }).toList();
  }

  // Get workout exercise with all its sets
  Future<WorkoutExerciseWithSets?> getWorkoutExerciseWithSets(int workoutExerciseId) async {
    final query = select(workoutExercises).join([
      innerJoin(exercises, exercises.id.equalsExp(workoutExercises.exerciseId)),
      leftOuterJoin(sets, sets.workoutExerciseId.equalsExp(workoutExercises.id)),
    ])
      ..where(workoutExercises.id.equals(workoutExerciseId));

    final rows = await query.get();
    if (rows.isEmpty) return null;

    final firstRow = rows.first;
    final workoutExercise = firstRow.readTable(workoutExercises);
    final exercise = firstRow.readTable(exercises);
    final setsList = <WorkoutSet>[];

    for (final row in rows) {
      final set = row.readTableOrNull(sets);
      if (set != null) {
        setsList.add(set);
      }
    }

    return WorkoutExerciseWithSets(
      workoutExercise: workoutExercise,
      exercise: exercise,
      sets: setsList,
    );
  }

  // Update workout exercise
  Future<int> updateWorkoutExercise(int id, WorkoutExercisesCompanion workoutExercise) async {
    return await (update(workoutExercises)..where((we) => we.id.equals(id)))
        .write(workoutExercise);
  }

  // Update notes for workout exercise
  Future<int> updateNotes(int id, String? notes) async {
    return await (update(workoutExercises)..where((we) => we.id.equals(id)))
        .write(WorkoutExercisesCompanion(notes: Value(notes)));
  }

  // Reorder exercises in workout
  Future<void> reorderExercises(int workoutId, List<int> exerciseIds) async {
    await transaction(() async {
      for (int i = 0; i < exerciseIds.length; i++) {
        await (update(workoutExercises)
              ..where((we) => we.id.equals(exerciseIds[i])))
            .write(WorkoutExercisesCompanion(
          orderInWorkout: Value(i + 1),
        ));
      }
    });
  }

  // Move exercise up/down in order
  Future<void> moveExercise(int workoutExerciseId, bool moveUp) async {
    final exercise = await (select(workoutExercises)
          ..where((we) => we.id.equals(workoutExerciseId)))
        .getSingle();

    final currentOrder = exercise.orderInWorkout;
    final newOrder = moveUp ? currentOrder - 1 : currentOrder + 1;

    if (newOrder < 1) return; // Can't move up if already first

    // Find exercise to swap with
    final swapExercise = await (select(workoutExercises)
          ..where((we) => we.workoutId.equals(exercise.workoutId))
          ..where((we) => we.orderInWorkout.equals(newOrder)))
        .getSingleOrNull();

    if (swapExercise == null) return; // Can't move down if already last

    // Swap orders
    await transaction(() async {
      await (update(workoutExercises)..where((we) => we.id.equals(exercise.id)))
          .write(WorkoutExercisesCompanion(orderInWorkout: Value(newOrder)));
      
      await (update(workoutExercises)..where((we) => we.id.equals(swapExercise.id)))
          .write(WorkoutExercisesCompanion(orderInWorkout: Value(currentOrder)));
    });
  }

  // Delete workout exercise (cascades to sets)
  Future<int> deleteWorkoutExercise(int id) async {
    // Sets should be deleted automatically via foreign key cascade
    return await (delete(workoutExercises)..where((we) => we.id.equals(id))).go();
  }

  // Delete all exercises for a workout
  Future<int> deleteAllWorkoutExercises(int workoutId) async {
    return await (delete(workoutExercises)
          ..where((we) => we.workoutId.equals(workoutId)))
        .go();
  }

  // Get next order number for workout
  Future<int> getNextOrderForWorkout(int workoutId) async {
    final maxOrder = await (selectOnly(workoutExercises)
          ..addColumns([workoutExercises.orderInWorkout.max()])
          ..where(workoutExercises.workoutId.equals(workoutId)))
        .getSingleOrNull();

    final currentMax = maxOrder?.read(workoutExercises.orderInWorkout.max());
    return (currentMax ?? 0) + 1;
  }

  // Check if exercise exists in workout
  Future<bool> exerciseExistsInWorkout(int workoutId, int exerciseId) async {
    final count = await (select(workoutExercises)
          ..where((we) => we.workoutId.equals(workoutId))
          ..where((we) => we.exerciseId.equals(exerciseId)))
        .get();
    
    return count.isNotEmpty;
  }

  // Get count of exercises in workout
  Future<int> getExerciseCount(int workoutId) async {
    final count = await (selectOnly(workoutExercises)
          ..addColumns([workoutExercises.id.count()])
          ..where(workoutExercises.workoutId.equals(workoutId)))
        .getSingle();

    return count.read(workoutExercises.id.count()) ?? 0;
  }

  // Watch exercises for a workout (real-time updates)
  Stream<List<WorkoutExerciseWithDetails>> watchWorkoutExercises(int workoutId) {
    final query = select(workoutExercises).join([
      innerJoin(exercises, exercises.id.equalsExp(workoutExercises.exerciseId)),
    ])
      ..where(workoutExercises.workoutId.equals(workoutId))
      ..orderBy([OrderingTerm.asc(workoutExercises.orderInWorkout)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final workoutExercise = row.readTable(workoutExercises);
        final exercise = row.readTable(exercises);
        
        return WorkoutExerciseWithDetails(
          workoutExercise: workoutExercise,
          exercise: exercise,
        );
      }).toList();
    });
  }
}

// Helper classes
class WorkoutExerciseWithDetails {
  final WorkoutExercise workoutExercise;
  final Exercise exercise;

  WorkoutExerciseWithDetails({
    required this.workoutExercise,
    required this.exercise,
  });
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