import 'package:food_delivery_restraunt/mysql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery_restraunt/classes/order_details.dart';

class Order {
  final int orderID;
  late String status;
  final int price;
  late List<OrderDetails> orderDetails = [];

  Order({required this.orderID, required this.status, required this.price}) {
    getOrderDetails(orderID);
  }

  static Future<List<Order>> getPendingOrders(int restaurantID) async {
    List<Order> orders = [];
    var db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT * FROM Orders WHERE restaurant_id=$restaurantID AND status <> "completed"');
    if (rows.isNotEmpty) {
      for (var row in rows) {
        orders.add(Order(
          orderID: int.parse(row.assoc()['order_id']!),
          status: row.assoc()['status']!,
          price: int.parse(row.assoc()['price']!),
        ));
      }
    }
    return orders;
  }

  void getOrderDetails(int orderID) async {
    List<OrderDetails> ordDetails = [];
    var db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT p.name, o.quantity, (o.quantity * p.price) AS total_price FROM OrderDetail o INNER JOIN Product p ON o.product_id=p.product_id WHERE o.order_id=$orderID;');
    if (rows.length >= 1) {
      for (var row in rows) {
        ordDetails.add(OrderDetails(
            name: row.assoc()['name']!,
            quantity: int.parse(row.assoc()['quantity']!),
            price: int.parse(row.assoc()['total_price']!)));
      }
    }
    orderDetails = ordDetails;
  }
}
