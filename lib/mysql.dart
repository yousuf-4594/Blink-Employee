import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/classes/CategorySales.dart';
import 'package:mysql_client/mysql_client.dart';

class Mysql {
  static String host = 'bqquhv7hiskomx4izkti-mysql.services.clever-cloud.com';
  static String user = 'ucavnwuvwpt2fdby';
  static String password = 'V8PQZ8r0QlbmEJriBE5f';
  static String db = 'bqquhv7hiskomx4izkti';

  static int port = 3306;

  Mysql();

  Future<MySQLConnection> getConnection() async {
    return await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
  }

  Future<Iterable<ResultSetRow>> getResults(String query) async {
    var conn = await getConnection();
    await conn.connect();
    var results = await conn.execute(query);
    conn.close();
    return results.rows;
  }

  Future<int> addProduct(
      String name, int restaurantID, categoryID, int price) async {
    var conn = await getConnection();
    await conn.connect();
    await conn.execute(
      'INSERT INTO Product (name, restaurant_id, category_id, price) VALUES ("$name", $restaurantID, $categoryID, $price);',
    );
    await conn.close();

    conn = await getConnection();
    await conn.connect();
    Iterable<ResultSetRow> rows = await getResults(
        'SELECT product_id FROM Product WHERE name="$name" AND restaurant_id=$restaurantID AND category_id=$categoryID AND price=$price');
    int productID = -1;
    if (rows.length > 0) {
      for (var row in rows) {
        productID = int.parse(row.assoc()['product_id']!);
        break;
      }
    }
    return productID;
  }

  void updateOrderStatus(int orderID, String status) async {
    var conn = await getConnection();
    await conn.connect();
    await conn
        .execute('UPDATE Orders SET status="$status" WHERE order_id=$orderID');
    await conn.close();
  }

  void deleteOrder(int orderID) async {
    var conn = await getConnection();
    await conn.connect();
    await conn.transactional((conn) async {
      await conn.execute("DELETE FROM OrderDetail WHERE order_id=$orderID");
      await conn.execute("DELETE FROM Orders WHERE order_id=$orderID");
    });
    conn.close();
  }

  Future<List<CategorySales>> getCategorySales(int restaurantID) async {
    List<CategorySales> temp = [];
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.teal,
      Colors.purple,
      Colors.pink,
      Colors.indigo,
      Colors.lightGreenAccent
    ];
    var db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT C.category_id, C.name, ROUND((SUM(P.price * D.quantity)/(SELECT SUM(PRICE) FROM Orders WHERE restaurant_id=$restaurantID AND status="completed")) * 100) AS percentage FROM Orders O INNER JOIN OrderDetail D ON (O.order_id = D.order_id) INNER JOIN Product P ON (D.product_id = P.product_id) INNER JOIN Category C ON (P.category_id = C.category_id) WHERE O.restaurant_id=$restaurantID AND O.status = "completed" GROUP BY category_id, name;');
    if (rows.length > 0) {
      for (var row in rows) {
        temp.add(CategorySales(
            categoryID: int.parse(row.assoc()['category_id']!),
            categoryName: row.assoc()['name']!,
            percentage: int.parse(row.assoc()['percentage']!),
            color: Colors.red));
      }
    }
    for (int i = 0; i < temp.length; i++) {
      temp[i].color = colors[i];
    }

    return temp;
  }
}
