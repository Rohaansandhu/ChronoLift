import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/categories_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(AppDatabase db) : super(db);

  // Get all categories (ordered by name)
  Future<List<Category>> getAllCategories() async {
    return await (select(categories)
      ..orderBy([(c) => OrderingTerm.asc(c.name)])).get();
  }

  // Get category by ID
  Future<Category?> getCategoryById(int id) async {
    return await (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  // Get category by UUID
  Future<Category?> getCategoryByUuid(String uuid) async {
    return await (select(categories)..where((c) => c.uuid.equals(uuid))).getSingleOrNull();
  }

  // Search categories by name
  Future<List<Category>> searchCategories(String query) async {
    return await (select(categories)
      ..where((c) => c.name.contains(query))
      ..orderBy([(c) => OrderingTerm.asc(c.name)])).get();
  }

  // Create category
  Future<int> createCategory(CategoriesCompanion category) async {
    return await into(categories).insert(category);
  }

  // Update category
  Future<int> updateCategory(int id, CategoriesCompanion category) async {
    return await (update(categories)..where((c) => c.id.equals(id))).write(category);
  }

  // Delete category
  Future<int> deleteCategory(int id) async {
    return await (delete(categories)..where((c) => c.id.equals(id))).go();
  }

  // Get distinct category names (shortcut)
  Future<List<String>> getCategoryNames() async {
    final query = selectOnly(categories, distinct: true)..addColumns([categories.name]);
    final results = await query.get();
    return results.map((row) => row.read(categories.name)!).toList();
  }
}
