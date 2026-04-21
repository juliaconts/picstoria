import 'package:flutter/material.dart';
import 'package:laboratory5/frontend/screens/home_screen.dart';
import 'package:laboratory5/frontend/widgets/add_entry_modal.dart';
import 'package:laboratory5/frontend/screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentPageIndex = 0;

  // Define the pages here so they are easy to swap
  final List<Widget> _pages = const [
    HomeScreen(),
    SizedBox(), // Placeholder for "Add" (it's a trigger, not a page)
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPageIndex],

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 1) {
            // "Add" is a trigger, NOT a tab, so we don't change the index
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const AddEntryModal(),
            );
          } else {
            // For Home (0) and Profile (2), we update the index normally
            setState(() {
              currentPageIndex = index;
            });
          }
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_circle),
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
