import 'package:chronolift/database/database.dart';
import 'package:chronolift/widgets/workout/add_category.dart';
import 'package:chronolift/widgets/workout/add_exercise.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseSelectorSheet extends StatefulWidget {
  final Function(Exercise)? onExerciseSelected;

  const ExerciseSelectorSheet({super.key, this.onExerciseSelected});

  static Future<void> show(
    BuildContext context, {
    Function(Exercise)? onExerciseSelected,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ExerciseSelectorSheet(
        onExerciseSelected: onExerciseSelected,
      ),
    );
  }

  @override
  State<ExerciseSelectorSheet> createState() => _ExerciseSelectorSheetState();
}

class _ExerciseSelectorSheetState extends State<ExerciseSelectorSheet> {
  final PageController _pageController = PageController();
  Map<String, List<Exercise>>? _categories;
  String? _selectedCategory;
  int? _selectedCategoryId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final database = context.read<AppDatabase>();
    final categoryDao = database.categoryDao;
    final exerciseDao = database.exerciseDao;
    final categories = await categoryDao.getAllCategories();
    final Map<String, List<Exercise>> categoryExerciseMap = {};

    for (final category in categories) {
      final exercises = await exerciseDao.getExercisesByCategory(category.id);
      categoryExerciseMap[category.name] = exercises;
    }

    setState(() {
      _categories = categoryExerciseMap;
      _isLoading = false;
    });
  }

  void _goToExercisePage(String category) async {
    final database = context.read<AppDatabase>();
    final categoryData = await database.categoryDao.getCategoryByName(category);
    
    setState(() {
      _selectedCategory = category;
      _selectedCategoryId = categoryData?.id;
    });
    
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goBackToCategories() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _selectExercise(Exercise exercise) {
    widget.onExerciseSelected?.call(exercise);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildCategoryPage(theme, scrollController),
            _buildExercisePage(theme, scrollController),
          ],
        );
      },
    );
  }

  Widget _buildCategoryPage(ThemeData theme, ScrollController scrollController) {
    return ListView.separated(
      controller: scrollController,
      itemCount: (_categories?.keys.length ?? 0) + 2,
      separatorBuilder: (_, __) => Divider(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        thickness: 1,
        height: 1,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Select Category",
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        if (index == 1) {
          return ListTile(
            leading: Icon(Icons.add, color: theme.colorScheme.primary),
            title: Text(
              "Add New Category",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            onTap: () async {
              final result = await AddCategoryDialog.show(context);
              if (result == true) {
                await _loadCategories();
              }
            },
          );
        }

        final category = _categories!.keys.elementAt(index - 2);
        final exerciseCount = _categories![category]!.length;

        return ListTile(
          title: Text(category, style: theme.textTheme.bodyLarge),
          subtitle: Text(
            '$exerciseCount exercises',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.colorScheme.tertiary,
          ),
          onTap: () => _goToExercisePage(category),
        );
      },
    );
  }

  Widget _buildExercisePage(ThemeData theme, ScrollController scrollController) {
    if (_selectedCategory == null) {
      return const SizedBox.shrink();
    }

    final categoryExercises = _categories![_selectedCategory]!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: _goBackToCategories,
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  "Select Exercise",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            itemCount: categoryExercises.length + 1,
            separatorBuilder: (_, __) => Divider(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              thickness: 1,
              height: 1,
            ),
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  leading: Icon(Icons.add, color: theme.colorScheme.primary),
                  title: Text(
                    "Add New Exercise",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  onTap: () async {
                    if (_selectedCategoryId != null) {
                      final newExercise = await AddExerciseDialog.show(
                        context,
                        categoryId: _selectedCategoryId!,
                        categoryName: _selectedCategory!,
                      );
                      
                      if (newExercise != null) {
                        await _loadCategories();
                        _selectExercise(newExercise);
                      }
                    }
                  },
                );
              }

              final exercise = categoryExercises[index - 1];
              return ListTile(
                title: Text(exercise.name, style: theme.textTheme.bodyLarge),
                subtitle: exercise.instructions != null
                    ? Text(
                        exercise.instructions!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                onTap: () => _selectExercise(exercise),
              );
            },
          ),
        ),
      ],
    );
  }
}