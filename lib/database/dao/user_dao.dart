import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/users_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  // Insert a new user
  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

  // Insert or update (handy for syncing with Supabase)
  Future<int> upsertUser(UsersCompanion user) =>
      into(users).insertOnConflictUpdate(user);

  // Get a single user by local id
  Future<User?> getUserById(int id) {
    return (select(users)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Get a user by UUID (for sync/auth use cases)
  Future<User?> getUserByUuid(String uuid) {
    return (select(users)..where((tbl) => tbl.uuid.equals(uuid)))
        .getSingleOrNull();
  }

  // Get current user
  Future<User?> getCurrentUser() {
    return (select(users)..where((tbl) => tbl.isCurrent)).getSingleOrNull();
  }

  // Set isCurrentUser flag to true/false
  Future<void> setCurrentUser(int id, bool newState) async {
    // Start a transaction to ensure atomic updates
    await transaction(() async {
      if (newState) {
        // First, set all users to NOT current
        await (update(users)).write(UsersCompanion(
          isCurrent: const Value(false),
        ));
      }
      
      // Then set the specified user to the new state
      await (update(users)..where((u) => u.id.equals(id)))
          .write(UsersCompanion(
            isCurrent: Value(newState),
          ));
    });
  }

  // Get all users (even if it’s rare you’ll have >1 on one device)
  Future<List<User>> getAllUsers() => select(users).get();

  // Watch users (auto-updates UI when data changes)
  Stream<List<User>> watchAllUsers() => select(users).watch();

  // Delete a user
  Future<int> deleteUserById(int id) =>
      (delete(users)..where((tbl) => tbl.id.equals(id))).go();
}
