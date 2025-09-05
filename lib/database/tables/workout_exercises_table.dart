import 'package:drift/drift.dart';
import 'workouts_table.dart';
import 'exercises_table.dart';

@DataClassName('WorkoutExercise')
class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  IntColumn get workoutId =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get orderInWorkout => integer()();
  TextColumn get notes => text().nullable()();
}
