import 'package:chronolift/auth/auth_gate.dart';
import 'package:chronolift/auth/auth_service.dart';
import 'package:chronolift/database/dao/category_dao.dart';
import 'package:chronolift/database/dao/exercise_dao.dart';
import 'package:chronolift/database/dao/workout_dao.dart';
import 'package:chronolift/database/dao/workout_exercise_dao.dart';
import 'package:chronolift/database/dao/workout_set_dao.dart';
import 'package:chronolift/database/database.dart';
import 'package:chronolift/models/workout_state.dart';
import 'package:chronolift/services/global_user_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Theme/lightmode.dart';
import 'Theme/darkmode.dart';
import 'models/exercise_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final supabaseUrl = dotenv.env['SUPABASE_URL']!.toString();
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!.toString();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        // Provide a single AppDatabase instance for the whole app
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, db) => db.close(),
        ),
        // Add GlobalUserService to load the current user
        ProxyProvider<AppDatabase, GlobalUserService>(
          update: (_, db, __) {
            final service = GlobalUserService.instance;
            service.initialize(db);
            // Eagerly load current user once at startup
            service.loadCurrentUser();
            return service;
          },
        ),
        ProxyProvider<GlobalUserService, AuthService>(
          update: (_, globalUser, __) => AuthService(globalUser),
        ),
        // ExerciseModel & WorkoutStateModel depend on AppDatabase, so build it using context.read
        ChangeNotifierProvider(
          create: (context) {
            final db = context.read<AppDatabase>();
            return ExerciseModel(ExerciseDao(db), CategoryDao(db));
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final db = context.read<AppDatabase>();
            return WorkoutStateModel(
                WorkoutDao(db), WorkoutExerciseDao(db), WorkoutSetDao(db));
          },
        )
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
