import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_restraunt/mysql.dart';
import 'package:mysql_client/mysql_client.dart';

class Analytics {
  static Future<int> getOrdersPlaced(String restaurantID) async {
    int count = 0;
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("orders").get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data["restaurant"]["restaurantid"] == restaurantID) {
          count++;
        }
      }
    } catch (e) {
      print(e);
    }
    return count;
  }

  static Future<int> getImpressions(String restaurantID) async {
    int count = 0;
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("restaurants")
          .doc(restaurantID)
          .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        count = data["views"];
      }
    } catch (e) {
      print(e);
    }
    return count;
  }

  static Future<int?> getRevenue(String restaurantID) async {
    int? revenue = 0;
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("orders").get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data["restaurant"]["restaurantid"] == restaurantID) {
          revenue = (revenue! + data["price"]) as int?;
        }
      }
    } catch (e) {
      print(e);
    }
    return revenue;
  }

  static Future<double> getReviewCount(String restaurantID) async {
    double count = 0;
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("restaurants")
          .doc(restaurantID)
          .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        count = data["Review"]["Rating Count"];
      }
    } catch (e) {
      print(e);
    }
    return count;
  }
}
