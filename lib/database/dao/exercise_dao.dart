import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/exercises_table.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase> with _$ExerciseDaoMixin {
  ExerciseDao(AppDatabase db) : super(db);

  // Get all exercises
  Future<List<Exercise>> getAllExercises() async {
    return await (select(exercises)..orderBy([(e) => OrderingTerm.asc(e.name)])).get();
  }

  // Get exercises by category
  Future<List<Exercise>> getExercisesByCategory(int categoryId) async {
    return await (select(exercises)..where((e) => e.categoryId.equals(categoryId))).get();
  }

  // Search exercises by name
  Future<List<Exercise>> searchExercises(String query) async {
    return await (select(exercises)
      ..where((e) => e.name.contains(query))
      ..orderBy([(e) => OrderingTerm.asc(e.name)]))
      .get();
  }

  // Create exercise
  Future<int> createExercise(ExercisesCompanion exercise) async {
    return await into(exercises).insert(exercise);
  }

  // Update exercise
  Future<int> updateExercise(int id, ExercisesCompanion exercise) async {
    return await (update(exercises)..where((e) => e.id.equals(id)))
        .write(exercise);
  }

  // Delete exercise
  Future<int> deleteExercise(int id) async {
    return await (delete(exercises)..where((e) => e.id.equals(id))).go();
  }

  // Get unique categories
  Future<List<int>> getCategories() async {
    final query = selectOnly(exercises, distinct: true)
      ..addColumns([exercises.categoryId]);
    
    final results = await query.get();
    return results.map((row) => row.read(exercises.categoryId)!).toList();
  }

  // Clear all exercises and return count
  Future<int> clearallExercises() async {
    final count = await (select(exercises)).get().then((list) => list.length);
    await delete(exercises).go();
    return count;
  }
}