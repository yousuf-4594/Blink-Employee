import 'package:cloud_firestore/cloud_firestore.dart';

import 'globals.dart';

class Restaurant {
  String restaurantID;
  String name;
  String ownerName;

  Restaurant(
      {required this.restaurantID,
      required this.name,
      required this.ownerName});

  static Future<Restaurant> getCurrentRestaurant() async {
    Restaurant restaurant = Restaurant(
        restaurantID: "undefined", name: "undefined", ownerName: "undefined");
    String? restaurantID = Global.getCurrentUser();

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("restaurants").get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data["uid"] == restaurantID) {
          restaurant = Restaurant(
              restaurantID: doc.id,
              name: data["name"],
              ownerName: data["ownername"]);
        }
      }
    } catch (e) {
      print(e);
    }

    return restaurant;
  }
}
