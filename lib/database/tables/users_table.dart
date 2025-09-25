import 'package:drift/drift.dart';

@DataClassName('User')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get email => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isCurrent => boolean().withDefault(Constant(false))();
}
