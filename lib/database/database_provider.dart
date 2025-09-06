import 'database.dart';

class DatabaseProvider {
  static AppDatabase? _database;
  
  static AppDatabase get database {
    _database ??= AppDatabase();
    return _database!;
  }
  
  static void closeDatabase() {
    _database?.close();
    _database = null;
  }
}