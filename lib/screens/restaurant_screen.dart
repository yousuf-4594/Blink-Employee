import 'package:flutter/material.dart';

class RestaurantScreen extends StatefulWidget {

  const RestaurantScreen({
    Key? key,
  }) : super(key: key);


  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text('screen'),
      ),
    );
  }
}