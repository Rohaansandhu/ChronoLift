import 'package:drift/drift.dart';
import 'workout_exercises_table.dart';

@DataClassName('WorkoutSet')
class Sets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  IntColumn get workoutExerciseId => integer()
      .references(WorkoutExercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get setNumber => integer()();
  RealColumn get weight => real().nullable()();
  IntColumn get reps => integer().nullable()();
  IntColumn get duration => integer().nullable()(); // seconds
  IntColumn get rpe => integer().nullable()(); // 1-10
  TextColumn get notes => text().nullable()();
  BoolColumn get isWarmup => boolean().withDefault(Constant(false))();
}
