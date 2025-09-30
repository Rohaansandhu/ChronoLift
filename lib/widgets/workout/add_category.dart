import 'package:chronolift/database/database.dart';
import 'package:chronolift/services/global_user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCategoryDialog {
  static Future<bool?> show(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        
        return AlertDialog(
          title: Text(
            'Add New Category',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Category Name',
                hintText: 'e.g., Upper Body, Cardio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.category),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a category name';
                }
                if (value.trim().length < 2) {
                  return 'Category name must be at least 2 characters';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final categoryName = nameController.text.trim();
                  final database = context.read<AppDatabase>();
                  final categoryDao = database.categoryDao;
                  
                  try {
                    // Check if category already exists
                    final existing = await categoryDao.getCategoryByName(categoryName);
                    if (existing != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Category "$categoryName" already exists'),
                          backgroundColor: theme.colorScheme.error,
                        ),
                      );
                      return;
                    }

                    // Get current user UUID
                    final globalUser = GlobalUserService.instance;
                    final uuid = globalUser.currentUserUuid!;

                    // Create the category
                    await categoryDao.createCategory(
                      CategoriesCompanion.insert(
                        uuid: uuid,
                        name: categoryName,
                      ),
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Category "$categoryName" created successfully'),
                          backgroundColor: theme.colorScheme.primary,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error creating category: $e'),
                          backgroundColor: theme.colorScheme.error,
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}