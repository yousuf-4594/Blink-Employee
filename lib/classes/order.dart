import 'package:food_delivery_restraunt/mysql.dart';
import 'package:mysql_client/mysql_client.dart';

class Order {
  final int orderID;
  final String status;
  final int price;

  Order({required this.orderID, required this.status, required this.price});

  static Future<List<Order>> getOrders(int restaurantID) async {
    List<Order> orders = [];
    var db = Mysql();
    Iterable<ResultSetRow> rows = await db
        .getResults('SELECT * FROM Orders WHERE restaurant_id=$restaurantID');
    if (rows.length > 0) {
      for (var row in rows) {
        orders.add(Order(
            orderID: int.parse(row.assoc()['order_id']!),
            status: row.assoc()['status']!,
            price: int.parse(row.assoc()['price']!)));
      }
    }
    return orders;
  }
}
