import 'package:food_delivery_restraunt/mysql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery_restraunt/classes/order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String orderID;
  late String status;
  final int price;
  final String customerID;
  late List<OrderDetails> orderDetails = [];

  Order({
    required this.orderID,
    required this.status,
    required this.price,
    required this.customerID,
    required this.orderDetails,
  }) {
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
  // static Future<List<Order>> getPendingOrders(int restaurantID) async {
  //   List<Order> ordersList = [];

  //   try {
  //     // Reference to the "orders" collection, filtering by restaurantID
  //     Query<Map<String, dynamic>> ordersQuery =
  //         FirebaseFirestore.instance.collection('orders');
  //     // .where('restaurantID', isEqualTo: "eWjuiXzb15xfWxNnEZai");

  //     // Get documents from the filtered query
  //     QuerySnapshot ordersSnapshot = await ordersQuery.get();
  //     print("aaa");
  //     // Iterate through each document
  //     for (QueryDocumentSnapshot orderDocument in ordersSnapshot.docs) {
  //       // Get document data as Map
  //       Map<String, dynamic> orderData =
  //           orderDocument.data() as Map<String, dynamic>;

  //       print(orderData);

  //       // Create an Order object from the retrieved data
  //       Order order = Order(
  //         // orderID: orderData['orderID'] as int,
  //         orderID: orderDocument.id as String,
  //         status: orderData['status'] as String,
  //         price: orderData['price'] as int,
  //       );
  //       print("order: $order ");

  //       order.getOrderDetails(orderData['Food items']);

  //       ordersList.add(order);
  //     }

  //     return ordersList;
  //   } catch (error) {
  //     print('Error fetching orders: $error');
  //     return [];
  //   }
  // }

  static Stream<List<Order>> getRealTimeOrders(String restaurantID) {
    try {
      CollectionReference ordersCollection =
          FirebaseFirestore.instance.collection('orders');

      // Use the snapshots() method to get a stream of document snapshots
      // data is filtered here
      return ordersCollection
          // .where('restaurant_id', isEqualTo: restaurantID)
          .where('status', whereIn: ["pending", "processing"])
          .snapshots()
          .map((querySnapshot) {
            // Convert each document snapshot to an Order object
            return querySnapshot.docs.map((orderDocument) {
              Map<String, dynamic> orderData =
                  orderDocument.data() as Map<String, dynamic>;

              print("order data: ${orderData['price']}");

              // Extract Food items from the order data
              List<OrderDetails> orderDetailsList = [];

              orderData['Food items'].forEach((foodItem) {
                // Iterate over each map in the array
                foodItem.forEach((foodName, foodData) {
                  // Extract Quantity and Price from the map
                  int quantity = foodData['Quantity'];
                  double price = foodData['Price'].toDouble();
                  print("a");

                  print('$foodName - Quantity: $quantity, Price: $price');
                  orderDetailsList.add(OrderDetails(
                    name: foodName,
                    quantity: foodData['Quantity'],
                    price: foodData['Price'],
                  ));
                });
              });

              print("eeo: $orderDetailsList");

              return Order(
                orderID: orderDocument.id,
                status: orderData['status'] ?? '',
                price: orderData['price'] ?? 0,
                customerID: orderData['customerid'],
                orderDetails: orderDetailsList,
              );
            }).toList();
          });
    } catch (error) {
      print('Error fetching real-time orders: $error');
      // Handle the error as needed
      return Stream.value([]);
    }
  }

  /*
      Function iterates a single order document and gets stores all fooditems inside
      into a Order class's member variable List:orderDetails 
  */
  static List<OrderDetails> getOrderDetails(
      Map<String, dynamic> foodItemsData) {
    List<OrderDetails> orderDetailsList = [];

    foodItemsData.forEach((itemName, itemData) {
      orderDetailsList.add(OrderDetails(
        name: itemName,
        quantity: itemData['Quantity'],
        price: itemData['Price'],
      ));
    });

    return orderDetailsList;
  }

  /*
      Updates an orders status from:
      pending -> processing
      processing -> completed

      can be put to (anystate) -> deleted at any instance
  */
  static Future<void> updateStatus(String orderId, String status) async {
    try {
      // Get a reference to the specific order document
      DocumentReference orderRef =
          FirebaseFirestore.instance.collection('orders').doc(orderId);

      // Update the "status" field to "deleted"
      await orderRef.update({'status': status});

      print('Order status updated to ${status} successfully!');
    } catch (error) {
      print('Error updating order status: $error');
      // Handle the error appropriately, e.g., show an error message to the user
    }
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
