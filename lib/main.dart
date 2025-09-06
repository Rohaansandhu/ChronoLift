import 'package:chronolift/auth/auth_gate.dart';
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

  await AppInitializer.initialize();

  await dotenv.load();
  final supabaseUrl = dotenv.env['SUPABASE_URL']!.toString();
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!.toString();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ExerciseModel()),
  ], child: const MyApp()));
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
