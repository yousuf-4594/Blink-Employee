import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/user.dart';
import 'package:food_delivery_restraunt/restaurant.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  int loginID = -1;
  User user;
  List<Restaurant> restaurants;

  HomeScreen({super.key, required this.user, required this.restaurants});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text('screen'),
      ),
    );
  }
}