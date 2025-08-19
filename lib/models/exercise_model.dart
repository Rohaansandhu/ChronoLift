import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

class ExerciseModel extends ChangeNotifier {
  Map<String, dynamic> _categories = {};
  bool _loaded = false;

  Map<String, dynamic> get categories => _categories;
  bool get isLoaded => _loaded;

  ExerciseModel() {
    load(); // automatically load when created
  }

  Future<void> load() async {
    if (_loaded) return;
    final jsonString = await rootBundle.loadString('assets/exercise_defaults.json');
    _categories = jsonDecode(jsonString);
    _loaded = true;
    notifyListeners();
  }
}
