import 'package:chronolift/pages/calendar_page.dart';
import 'package:chronolift/pages/settings_page.dart';
import 'package:chronolift/pages/stats_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class MainNavPage extends StatefulWidget {
  const MainNavPage({super.key});

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int currentIndex = 0; // Default to Home page

  // List of pages - each page is a separate widget
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const HomePage(),
      const StatsPage(),
      const CalendarPage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex], // Display the selected page
      bottomNavigationBar: SizedBox(
        height: 100,
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          selectedIndex: currentIndex,
          indicatorColor: Theme.of(context).colorScheme.inversePrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart),
              label: "Stats",
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined), 
              label: "Calendar"
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}