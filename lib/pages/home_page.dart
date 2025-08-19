import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronolift/models/workout_log_model.dart';
import 'workout_page.dart';
import 'package:shiny_button/shiny_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutLogModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Workout Log",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              IconButton(
                onPressed: () => model.logout(context),
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
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create: (_) => WorkoutState(), child: const WorkoutPage())),
                    );
                  },
                  label: 'New Workout',
                  icon: const Icon(Icons.add, color: Colors.black),
                  backgroundColor: const Color(0xFFFFD6A5),
                  textColor: Colors.black87,
                  shineDirection: ShineDirection.leftToRight,
                  iconPosition: IconPosition.leading,
                  tooltip: 'Start a new workout',
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  borderRadius: 16.0,
                  elevation: 4.0,
                  shadowColor: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              // Logs
              Expanded(
                child: model.logs.isEmpty
                    ? const Center(child: Text("No Logs Yet..."))
                    : NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              !model.isLoadingMore) {
                            model.loadMoreLogs();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount: model.logs.length + (model.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == model.logs.length) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }

                            final logData =
                                model.logs[index].data() as Map<String, dynamic>;
                            final date = (logData['date'] as Timestamp).toDate();

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text(logData['title'] ?? 'Workout'),
                                subtitle: Text(
                                  "${date.toLocal()}",
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
