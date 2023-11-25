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
}
