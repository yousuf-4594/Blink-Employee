import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/screens/home_screen.dart';
import 'package:food_delivery_restraunt/screens/restaurant_screen.dart';
import 'package:food_delivery_restraunt/screens/settings_screen.dart';
import 'package:food_delivery_restraunt/screens/menu_screen.dart';
import 'package:food_delivery_restraunt/screens/analytics_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:food_delivery_restraunt/screens/login_screen.dart';
import 'package:food_delivery_restraunt/user.dart';
import 'package:food_delivery_restraunt/arguments/home_screen_arguments.dart';

class MainNavigator extends StatefulWidget {
  static const id = 'main-navigator';
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    HomeScreenArguments homeScreenArguments =
        ModalRoute.of(context)!.settings.arguments as HomeScreenArguments;
    return Scaffold(
      bottomNavigationBar: GNav(
        rippleColor: Colors.grey[300]!,
        hoverColor: Colors.grey[100]!,
        gap: 8,
        activeColor: Colors.black,
        iconSize: 24,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
        duration: Duration(milliseconds: 400),
        tabBackgroundColor: Colors.grey[100]!,
        color: Colors.black,
        onTabChange: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        tabs: const [
          GButton(
            icon: Icons.store_rounded,
            text: 'Home',
          ),
          GButton(
            icon: Icons.all_inclusive_rounded,
            text: 'Analytics',
          ),
          GButton(
            icon: Icons.restaurant_menu_rounded,
            text: 'Menu',
          ),
          GButton(
            icon: Icons.settings_rounded,
            text: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        HomeScreen(
          restaurant: homeScreenArguments.restaurant,
        ),
        // LoginScreen(),
        AnalyticsScreen(),
        MenuScreen(),
        SettingsScreen(),
      ][currentPageIndex],
    );
  }
}
