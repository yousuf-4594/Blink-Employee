import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_restraunt/classes/restaurant.dart';

class Global {
  static Restaurant restaurant = Restaurant(
      restaurantID: "restaurantID", name: "name", ownerName: "ownerName");

  static String? getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user!.uid;
  }

  static Future<bool> isRestaurant(String restaurantID) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("restaurants").get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data["uid"] == restaurantID) {
          return true;
        }
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}
