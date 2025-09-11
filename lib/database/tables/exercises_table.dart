import 'package:chronolift/database/tables/categories_table.dart';
import 'package:drift/drift.dart';

@DataClassName('Exercise')
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  TextColumn get name => text().unique()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get instructions => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
