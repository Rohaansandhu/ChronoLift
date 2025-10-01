import 'package:chronolift/services/global_user_service.dart';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/categories_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(super.db);

  // Get all categories for current user (ordered by name)
  Future<List<Category>> getAllCategories() async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;
    
    return await (select(categories)
          ..where((c) => c.uuid.equals(uuid))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  // Get category by ID (verify UUID ownership)
  Future<Category?> getCategoryById(int id) async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;
    
    return await (select(categories)
          ..where((c) => c.id.equals(id) & c.uuid.equals(uuid)))
        .getSingleOrNull();
  }

  // Get category by UUID 
  Future<Category?> getCategoryByUuid(String uuid) async {
    return await (select(categories)..where((c) => c.uuid.equals(uuid)))
        .getSingleOrNull();
  }

  // Get category by name for current user
  Future<Category?> getCategoryByName(String name) async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;
    
    return await (select(categories)
          ..where((c) => c.name.equals(name) & c.uuid.equals(uuid)))
        .getSingleOrNull();
  }

  // Create category
  Future<int> createCategory(CategoriesCompanion category) async {
    return await into(categories).insert(category);
  }

  // Update category (verify UUID ownership)
  Future<int> updateCategory(int id, CategoriesCompanion category) async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;
    
    return await (update(categories)
          ..where((c) => c.id.equals(id) & c.uuid.equals(uuid)))
        .write(category);
  }

  // Delete category (verify UUID ownership)
  Future<int> deleteCategory(int id) async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;
    
    return await (delete(categories)
          ..where((c) => c.id.equals(id) & c.uuid.equals(uuid)))
        .go();
  }

  // Get distinct category names for current user
  Future<List<String>> getCategoryNames() async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;
    
    final query = selectOnly(categories, distinct: true)
      ..addColumns([categories.name])
      ..where(categories.uuid.equals(uuid));
    
    final results = await query.get();
    return results.map((row) => row.read(categories.name)!).toList();
  }

  // Delete all categories for current user and return count 
  Future<int> clearAllCategories() async {
    final globalUser = GlobalUserService.instance;
    final uuid = globalUser.currentUserUuid!;
    
    final count = await (select(categories)
          ..where((c) => c.uuid.equals(uuid)))
        .get()
        .then((list) => list.length);
    
    await (delete(categories)..where((c) => c.uuid.equals(uuid))).go();
    return count;
  }
}
