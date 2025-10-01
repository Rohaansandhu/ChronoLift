import 'package:chronolift/services/global_user_service.dart';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/exercises_table.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  // Get all exercises for current user
  Future<List<Exercise>> getAllExercises() async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;

    return await (select(exercises)
          ..where((e) => e.uuid.equals(uuid))
          ..orderBy([(e) => OrderingTerm.asc(e.name)]))
        .get();
  }

  // Get exercises by category for current user
  Future<List<Exercise>> getExercisesByCategory(int categoryId) async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;

    return await (select(exercises)
          ..where((e) => e.categoryId.equals(categoryId) & e.uuid.equals(uuid)))
        .get();
  }

  // Search exercises by name for current user
  Future<List<Exercise>> searchExercises(String query) async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;

    return await (select(exercises)
          ..where((e) => e.name.contains(query) & e.uuid.equals(uuid))
          ..orderBy([(e) => OrderingTerm.asc(e.name)]))
        .get();
  }

  // Create exercise
  Future<int> createExercise(ExercisesCompanion exercise) async {
    return await into(exercises).insert(exercise);
  }

  // Update exercise (verify UUID ownership)
  Future<int> updateExercise(int id, ExercisesCompanion exercise) async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;

    return await (update(exercises)
          ..where((e) => e.id.equals(id) & e.uuid.equals(uuid)))
        .write(exercise);
  }

  // Delete exercise (verify UUID ownership)
  Future<int> deleteExercise(int id) async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;

    return await (delete(exercises)
          ..where((e) => e.id.equals(id) & e.uuid.equals(uuid)))
        .go();
  }

  // Get unique categories for current user
  Future<List<int>> getCategories() async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;

    final query = selectOnly(exercises, distinct: true)
      ..addColumns([exercises.categoryId])
      ..where(exercises.uuid.equals(uuid));

    final results = await query.get();
    return results.map((row) => row.read(exercises.categoryId)!).toList();
  }

  // Clear all exercises for current user and return count
  Future<int> clearallExercises() async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;

    final count = await (select(exercises)..where((e) => e.uuid.equals(uuid)))
        .get()
        .then((list) => list.length);

    await (delete(exercises)..where((e) => e.uuid.equals(uuid))).go();
    return count;
  }
}
