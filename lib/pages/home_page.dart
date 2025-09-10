import 'package:chronolift/auth/auth_gate.dart';
import 'package:chronolift/services/global_user_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// TODO: Import your Drift database models here
// TODO: Import your workout models/services here
import 'workout_page.dart';
import 'package:shiny_button/shiny_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with your workout service/provider
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workout Log",
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () async {
              globalUser.clearCurrentUser();
              await Supabase.instance.client.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const SizedBox(height: 20),

          // New Workout Button
          SizedBox(
            height: 80,
            width: 275,
            child: ShinyButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkoutPage()),
                );
              },
              label: 'New Workout',
              icon: const Icon(Icons.add, color: Colors.black),
              backgroundColor: const Color(0xFFFFD6A5),
              textColor: Colors.black87,
              shineDirection: ShineDirection.leftToRight,
              iconPosition: IconPosition.leading,
              tooltip: 'Start a new workout',
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              borderRadius: 16.0,
              elevation: 4.0,
              shadowColor: Colors.black54,
            ),
          ),

          const SizedBox(height: 20),

          // Workout Logs
          Expanded(
            child: FutureBuilder(
              // TODO: Replace with your database query to get workouts
              // Example: future: database.workoutDao.getAllWorkouts(),
              future: _getWorkouts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                // TODO: Replace with your workout data type
                final workouts = snapshot.data ?? [];

                if (workouts.isEmpty) {
                  return const Center(child: Text("No Logs Yet..."));
                }

                return ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    // TODO: Replace with your workout data structure
                    final workout = workouts[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          // TODO: Replace with your workout name field
                          'Workout Name', // workout.name ?? 'Workout'
                        ),
                        subtitle: Text(
                          // TODO: Replace with your workout date field
                          'Workout Date', // workout.date.toString()
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        onTap: () {
                          // TODO: Navigate to workout details
                          // Navigator.push(context, MaterialPageRoute(
                          //   builder: (context) => WorkoutDetailPage(workout: workout),
                          // ));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Replace with your actual database query
  Future<List<dynamic>> _getWorkouts() async {
    // Placeholder - replace with your Drift database call
    // Example: return await database.workoutDao.getAllWorkouts();
    return [];
  }
}
