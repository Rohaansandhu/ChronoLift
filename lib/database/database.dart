import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Import table files
import 'tables/workouts_table.dart';
import 'tables/exercises_table.dart';
import 'tables/workout_exercises_table.dart';
import 'tables/workout_sets_table.dart';
import 'tables/users_table.dart';
import 'tables/categories_table.dart';

// Import DAOs
import 'dao/workout_dao.dart';
import 'dao/exercise_dao.dart';
import 'dao/user_dao.dart';
import 'package:chronolift/database/dao/category_dao.dart';
import 'package:chronolift/database/dao/workout_exercise_dao.dart';
import 'package:chronolift/database/dao/workout_set_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Workouts, Exercises, WorkoutExercises, Sets, Users, Categories],
  daos: [WorkoutDao, ExerciseDao, UserDao, CategoryDao, WorkoutExerciseDao, WorkoutSetDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();

          // Insert some default exercises
          // await _insertDefaultExercises();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Handle database upgrades here
        },
      );

  // Future<void> _insertDefaultExercises() async {
  //   final defaultExercises = [
  //     ExercisesCompanion.insert(
  //       name: 'Bench Press',
  //       categoryId: 'Chest',
  //     ),
  //     ExercisesCompanion.insert(
  //       name: 'Squats',
  //       categoryId: 'Legs',
  //     ),
  //     ExercisesCompanion.insert(
  //       name: 'Deadlift',
  //       categoryId: 'Back',
  //     ),
  //     // Add more default exercises
  //   ];

  //   for (final exercise in defaultExercises) {
  //     await into(exercises).insertOnConflictUpdate(exercise);
  //   }
  // }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'workout_tracker.db'));
    return NativeDatabase.createInBackground(file);
  });
}
