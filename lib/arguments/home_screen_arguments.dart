import 'package:food_delivery_restraunt/user.dart';
import 'package:food_delivery_restraunt/restaurant.dart';

class HomeScreenArguments {
  User user;
  List<Restaurant> restaurants;

  HomeScreenArguments({required this.user, required this.restaurants});
}
