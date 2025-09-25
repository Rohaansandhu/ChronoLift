import 'package:chronolift/auth/auth_gate.dart';
import 'package:chronolift/database/dao/category_dao.dart';
import 'package:chronolift/database/dao/exercise_dao.dart';
import 'package:chronolift/database/dao/user_dao.dart';
import 'package:chronolift/database/dao/workout_dao.dart';
import 'package:chronolift/database/dao/workout_exercise_dao.dart';
import 'package:chronolift/database/dao/workout_set_dao.dart';
import 'package:chronolift/database/database.dart';
import 'package:chronolift/models/workout_log_model.dart';
import 'package:chronolift/models/workout_state.dart';
import 'package:chronolift/seed_data.dart';
import 'package:chronolift/services/global_user_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Theme/lightmode.dart';
import 'Theme/darkmode.dart';
import 'models/exercise_model.dart';

// Global instances of drift db and current user
late AppDatabase db;
late GlobalUserService globalUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final supabaseUrl = dotenv.env['SUPABASE_URL']!.toString();
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!.toString();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // IMPORTANT: Initializes the Drift DB, only run this once
  db = AppDatabase();

  // Initialize the global user service to keep track of local user
  globalUser = GlobalUserService.instance;
  globalUser.initialize(db);
  await globalUser.loadCurrentUser();

  // Seed default exercise and categories if necessary on startup
  // TODO: Sync from Cloud if exercise and categories have changed
  await seedDefaultsIfEmpty(db);

  runApp(
    MultiProvider(
      providers: [
        // Provide a single AppDatabase instance to access with build context
        Provider<AppDatabase>(
          create: (_) => db,
          dispose: (_, db) => db.close(),
        ),
        // DAOs
        Provider<ExerciseDao>(
          create: (context) => ExerciseDao(context.read<AppDatabase>()),
        ),
        Provider<CategoryDao>(
          create: (context) => CategoryDao(context.read<AppDatabase>()),
        ),
        Provider<UserDao>(
          create: (context) => UserDao(context.read<AppDatabase>()),
        ),
        Provider<WorkoutDao>(
          create: (context) => WorkoutDao(context.read<AppDatabase>()),
        ),
        Provider<WorkoutExerciseDao>(
          create: (context) => WorkoutExerciseDao(context.read<AppDatabase>()),
        ),
        Provider<WorkoutSetDao>(
          create: (context) => WorkoutSetDao(context.read<AppDatabase>()),
        ),
        // Model providers
        ChangeNotifierProvider<ExerciseModel>(
          create: (context) => ExerciseModel(
            context.read<ExerciseDao>(),
            context.read<CategoryDao>(),
          ),
        ),
        ChangeNotifierProvider<WorkoutStateModel>(
          create: (context) => WorkoutStateModel(
            context.read<WorkoutDao>(),
            context.read<WorkoutExerciseDao>(),
            context.read<WorkoutSetDao>(),
          ),
        ),
        ChangeNotifierProvider<WorkoutLogModel>(
          create: (context) => WorkoutLogModel(
            context.read<WorkoutDao>(),
            context.read<WorkoutExerciseDao>(),
            context.read<WorkoutSetDao>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise App',
      debugShowCheckedModeBanner: false,
      theme: lightmode,
      darkTheme: darkmode,
      home: const AuthGate(),
    );
  }
}
