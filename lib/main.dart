import 'package:chronolift/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Theme/lightmode.dart';
import 'Theme/darkmode.dart';
import 'models/exercise_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ExerciseModel()),
    ],
    child: const MyApp()
    )
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
