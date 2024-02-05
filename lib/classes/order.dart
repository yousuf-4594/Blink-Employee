import 'package:food_delivery_restraunt/mysql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery_restraunt/classes/order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final int orderID;
  late String status;
  final int price;
  late List<OrderDetails> orderDetails = [];

  Order({required this.orderID, required this.status, required this.price}) {
    // getOrderDetails(orderID);
  }

  // static Future<List<Order>> getPendingOrders(int restaurantID) async {
  //   List<Order> orders = [];
  //   var db = Mysql();
  //   Iterable<ResultSetRow> rows = await db.getResults(
  //       'SELECT * FROM Orders WHERE restaurant_id=$restaurantID AND status <> "completed"');
  //   if (rows.isNotEmpty) {
  //     for (var row in rows) {
  //       orders.add(Order(
  //         orderID: int.parse(row.assoc()['order_id']!),
  //         status: row.assoc()['status']!,
  //         price: int.parse(row.assoc()['price']!),
  //       ));
  //     }
  //   }
  //   return orders;
  // }

  /*
    Fetches all orders of a specific restaurant
    and displays it onto homepage for employee to foresee
  */
  static Future<List<Order>> getPendingOrders(int restaurantID) async {
    List<Order> ordersList = [];

    try {
      // Reference to the "orders" collection, filtering by restaurantID
      Query<Map<String, dynamic>> ordersQuery =
          FirebaseFirestore.instance.collection('orders');
      // .where('restaurantID', isEqualTo: "eWjuiXzb15xfWxNnEZai");

      // Get documents from the filtered query
      QuerySnapshot ordersSnapshot = await ordersQuery.get();
      print("aaa");
      // Iterate through each document
      for (QueryDocumentSnapshot orderDocument in ordersSnapshot.docs) {
        // Get document data as Map
        Map<String, dynamic> orderData =
            orderDocument.data() as Map<String, dynamic>;

        print(orderData);

        // Create an Order object from the retrieved data
        Order order = Order(
          // orderID: orderData['orderID'] as int,
          orderID: 100,
          status: orderData['status'] as String,
          price: orderData['price'] as int,
        );
        print("order: $order ");

        order.getOrderDetails(orderData['Food items']);

        ordersList.add(order);
      }

      return ordersList;
    } catch (error) {
      print('Error fetching orders: $error');
      return [];
    }
  }

  /*
      Function iterates a single order document and gets stores all fooditems inside
      into a Order class's member variable List:orderDetails 
  */
  void getOrderDetails(Map<String, dynamic> foodItems) {
    List<OrderDetails> ordDetails = [];

    foodItems.forEach((foodItemName, foodItemData) {
      ordDetails.add(OrderDetails(
          name: foodItemName,
          quantity: foodItemData['Quantity'],
          price: foodItemData['Price']));

       print('$foodItemName:');
    print('  Price: ${foodItemData['Price']}');
    print('  Quantity: ${foodItemData['Quantity']}');   
    });

    orderDetails = ordDetails;
  }

  // void getOrderDetails(int orderID) async {
  //   List<OrderDetails> ordDetails = [];
  //   var db = Mysql();
  //   Iterable<ResultSetRow> rows = await db.getResults(
  //       'SELECT p.name, o.quantity, (o.quantity * p.price) AS total_price FROM OrderDetail o INNER JOIN Product p ON o.product_id=p.product_id WHERE o.order_id=$orderID;');
  //   if (rows.length >= 1) {
  //     for (var row in rows) {
  //       ordDetails.add(OrderDetails(
  //           name: row.assoc()['name']!,
  //           quantity: int.parse(row.assoc()['quantity']!),
  //           price: int.parse(row.assoc()['total_price']!)));
  //     }
  //   }
  //   orderDetails = ordDetails;
  // }
}
