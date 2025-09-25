import 'package:chronolift/services/global_user_service.dart';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/workout_sets_table.dart';
import '../tables/workout_exercises_table.dart';
import '../tables/exercises_table.dart';

part 'workout_set_dao.g.dart';

@DriftAccessor(tables: [Sets, WorkoutExercises, Exercises])
class WorkoutSetDao extends DatabaseAccessor<AppDatabase> with _$WorkoutSetDaoMixin {
  WorkoutSetDao(super.db);

  // Create a new set
  Future<int> createSet(SetsCompanion set) async {
    return await into(sets).insert(set);
  }

  // Add set with automatic numbering
  Future<int> addSet({
    required int workoutExerciseId,
    int? setNumber,
    double? weight,
    int? reps,
    int? duration,
    int? rpe,
    String? notes,
    bool isWarmup = false,
  }) async {
    final uuid = globalUser.currentUserUuid!;
    
    // If no set number specified, get the next set number
    int number = setNumber ?? await getNextSetNumber(workoutExerciseId);
    
    return await into(sets).insert(
      SetsCompanion.insert(
        workoutExerciseId: workoutExerciseId,
        setNumber: number,
        weight: Value(weight),
        reps: Value(reps),
        duration: Value(duration),
        rpe: Value(rpe),
        notes: Value(notes),
        isWarmup: Value(isWarmup),
        uuid: uuid,
      ),
    );
  }

  // Get all sets for a workout exercise
  Future<List<WorkoutSet>> getSetsForExercise(int workoutExerciseId) async {
    return await (select(sets)
          ..where((s) => s.workoutExerciseId.equals(workoutExerciseId))
          ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
        .get();
  }

  // Get all sets for a workout (across all exercises)
  Future<List<SetWithExercise>> getSetsForWorkout(int workoutId) async {
    final query = select(sets).join([
      innerJoin(workoutExercises, workoutExercises.id.equalsExp(sets.workoutExerciseId)),
      innerJoin(exercises, exercises.id.equalsExp(workoutExercises.exerciseId)),
    ])
      ..where(workoutExercises.workoutId.equals(workoutId))
      ..orderBy([
        OrderingTerm.asc(workoutExercises.orderInWorkout),
        OrderingTerm.asc(sets.setNumber),
      ]);

    final rows = await query.get();
    
    return rows.map((row) {
      final set = row.readTable(sets);
      final workoutExercise = row.readTable(workoutExercises);
      final exercise = row.readTable(exercises);
      
      return SetWithExercise(
        set: set,
        workoutExercise: workoutExercise,
        exercise: exercise,
      );
    }).toList();
  }

  // Update a set
  Future<int> updateSet(int id, SetsCompanion set) async {
    return await (update(sets)..where((s) => s.id.equals(id)))
        .write(set);
  }

  // Quick update methods for common operations
  Future<int> updateWeight(int id, double weight) async {
    return await (update(sets)..where((s) => s.id.equals(id)))
        .write(SetsCompanion(weight: Value(weight)));
  }

  Future<int> updateReps(int id, int reps) async {
    return await (update(sets)..where((s) => s.id.equals(id)))
        .write(SetsCompanion(reps: Value(reps)));
  }

  Future<int> updateDuration(int id, int duration) async {
    return await (update(sets)..where((s) => s.id.equals(id)))
        .write(SetsCompanion(duration: Value(duration)));
  }

  Future<int> updateRpe(int id, int rpe) async {
    return await (update(sets)..where((s) => s.id.equals(id)))
        .write(SetsCompanion(rpe: Value(rpe)));
  }

  Future<int> toggleWarmup(int id) async {
    final set = await (select(sets)..where((s) => s.id.equals(id))).getSingle();
    
    return await (update(sets)..where((s) => s.id.equals(id)))
        .write(SetsCompanion(isWarmup: Value(!set.isWarmup)));
  }

  // Delete a set
  Future<int> deleteSet(int id) async {
    // Get the set to be deleted
    final setToDelete = await (select(sets)..where((s) => s.id.equals(id))).getSingle();
    
    // Delete the set
    final deleted = await (delete(sets)..where((s) => s.id.equals(id))).go();
    
    // Renumber remaining sets
    await renumberSets(setToDelete.workoutExerciseId);
    
    return deleted;
  }

  // Delete all sets for a workout exercise
  Future<int> deleteAllSetsForExercise(int workoutExerciseId) async {
    return await (delete(sets)
          ..where((s) => s.workoutExerciseId.equals(workoutExerciseId)))
        .go();
  }

  // Duplicate a set (useful for adding similar sets quickly)
  Future<int> duplicateSet(int setId) async {
    final originalSet = await (select(sets)..where((s) => s.id.equals(setId))).getSingle();
    final nextNumber = await getNextSetNumber(originalSet.workoutExerciseId);
    
    return await into(sets).insert(
      SetsCompanion.insert(
        workoutExerciseId: originalSet.workoutExerciseId,
        setNumber: nextNumber,
        weight: Value(originalSet.weight),
        reps: Value(originalSet.reps),
        duration: Value(originalSet.duration),
        rpe: Value(originalSet.rpe),
        notes: Value(originalSet.notes),
        isWarmup: Value(originalSet.isWarmup),
        uuid: originalSet.uuid,
      ),
    );
  }

  // Bulk duplicate sets (duplicate last set N times)
  Future<void> duplicateLastSetMultiple(int workoutExerciseId, int count) async {
    final lastSet = await (select(sets)
          ..where((s) => s.workoutExerciseId.equals(workoutExerciseId))
          ..orderBy([(s) => OrderingTerm.desc(s.setNumber)])
          ..limit(1))
        .getSingleOrNull();

    if (lastSet == null) return;

    await transaction(() async {
      for (int i = 0; i < count; i++) {
        await duplicateSet(lastSet.id);
      }
    });
  }

  // Get next set number for an exercise
  Future<int> getNextSetNumber(int workoutExerciseId) async {
    final maxSetNumber = await (selectOnly(sets)
          ..addColumns([sets.setNumber.max()])
          ..where(sets.workoutExerciseId.equals(workoutExerciseId)))
        .getSingleOrNull();

    final currentMax = maxSetNumber?.read(sets.setNumber.max());
    return (currentMax ?? 0) + 1;
  }

  // Renumber sets after deletion
  Future<void> renumberSets(int workoutExerciseId) async {
    final allSets = await (select(sets)
          ..where((s) => s.workoutExerciseId.equals(workoutExerciseId))
          ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
        .get();

    await transaction(() async {
      for (int i = 0; i < allSets.length; i++) {
        if (allSets[i].setNumber != i + 1) {
          await (update(sets)..where((s) => s.id.equals(allSets[i].id)))
              .write(SetsCompanion(setNumber: Value(i + 1)));
        }
      }
    });
  }

  // Get set count for exercise
  Future<int> getSetCount(int workoutExerciseId) async {
    final count = await (selectOnly(sets)
          ..addColumns([sets.id.count()])
          ..where(sets.workoutExerciseId.equals(workoutExerciseId)))
        .getSingle();

    return count.read(sets.id.count()) ?? 0;
  }

  // Get working sets count (non-warmup)
  Future<int> getWorkingSetCount(int workoutExerciseId) async {
    final count = await (selectOnly(sets)
          ..addColumns([sets.id.count()])
          ..where(sets.workoutExerciseId.equals(workoutExerciseId))
          ..where(sets.isWarmup.equals(false)))
        .getSingle();

    return count.read(sets.id.count()) ?? 0;
  }

  // Calculate total volume for an exercise
  Future<double> getTotalVolume(int workoutExerciseId) async {
    final volume = await (selectOnly(sets)
          ..addColumns([(sets.weight * sets.reps.cast<double>()).sum()])
          ..where(sets.workoutExerciseId.equals(workoutExerciseId))
          ..where(sets.isWarmup.equals(false)))
        .getSingleOrNull();

    return volume?.read((sets.weight * sets.reps.cast<double>()).sum()) ?? 0.0;
  }

  // Get best set (highest weight × reps) for an exercise
  Future<WorkoutSet?> getBestSet(int workoutExerciseId) async {
    final allSets = await (select(sets)
          ..where((s) => s.workoutExerciseId.equals(workoutExerciseId))
          ..where((s) => s.isWarmup.equals(false)))
        .get();

    if (allSets.isEmpty) return null;

    WorkoutSet? bestSet;
    double maxVolume = 0;

    for (final set in allSets) {
      if (set.weight != null && set.reps != null) {
        final volume = set.weight! * set.reps!;
        if (volume > maxVolume) {
          maxVolume = volume;
          bestSet = set;
        }
      }
    }

    return bestSet;
  }

  // Get previous best for an exercise (for progression tracking)
  Future<PreviousBest?> getPreviousBest(int exerciseId, {int? excludeWorkoutId}) async {
    final query = select(sets).join([
      innerJoin(workoutExercises, workoutExercises.id.equalsExp(sets.workoutExerciseId)),
    ])
      ..where(workoutExercises.exerciseId.equals(exerciseId))
      ..where(sets.isWarmup.equals(false));

    if (excludeWorkoutId != null) {
      query.where(workoutExercises.workoutId.isNotValue(excludeWorkoutId));
    }

    final rows = await query.get();
    
    if (rows.isEmpty) return null;

    double maxWeight = 0;
    int maxReps = 0;
    double maxVolume = 0;

    for (final row in rows) {
      final set = row.readTable(sets);
      
      if (set.weight != null) {
        maxWeight = set.weight! > maxWeight ? set.weight! : maxWeight;
      }
      
      if (set.reps != null) {
        maxReps = set.reps! > maxReps ? set.reps! : maxReps;
      }
      
      if (set.weight != null && set.reps != null) {
        final volume = set.weight! * set.reps!;
        maxVolume = volume > maxVolume ? volume : maxVolume;
      }
    }

    return PreviousBest(
      maxWeight: maxWeight,
      maxReps: maxReps,
      maxVolume: maxVolume,
    );
  }

  // Watch sets for an exercise (real-time updates)
  Stream<List<WorkoutSet>> watchSetsForExercise(int workoutExerciseId) {
    return (select(sets)
          ..where((s) => s.workoutExerciseId.equals(workoutExerciseId))
          ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
        .watch();
  }

  // Get rest-pause sets
  Future<List<WorkoutSet>> getRestPauseSets(int workoutExerciseId) async {
    return await (select(sets)
          ..where((s) => s.workoutExerciseId.equals(workoutExerciseId))
          ..where((s) => s.notes.contains('rest-pause')))
        .get();
  }

  // Get drop sets
  Future<List<WorkoutSet>> getDropSets(int workoutExerciseId) async {
    return await (select(sets)
          ..where((s) => s.workoutExerciseId.equals(workoutExerciseId))
          ..where((s) => s.notes.contains('drop set')))
        .get();
  }
}

// Helper classes
class SetWithExercise {
  final WorkoutSet set;
  final WorkoutExercise workoutExercise;
  final Exercise exercise;

  SetWithExercise({
    required this.set,
    required this.workoutExercise,
    required this.exercise,
  });
}

class PreviousBest {
  final double maxWeight;
  final int maxReps;
  final double maxVolume;

  PreviousBest({
    required this.maxWeight,
    required this.maxReps,
    required this.maxVolume,
  });
}