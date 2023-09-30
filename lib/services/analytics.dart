import 'package:food_delivery_restraunt/mysql.dart';
import 'package:mysql_client/mysql_client.dart';

class Analytics {
  static Future<int> getOrdersPlaced(int restaurantID) async {
    int count = 0;
    Mysql db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT COUNT(*) AS count FROM Orders WHERE restaurant_id = $restaurantID;');
    if (rows.isNotEmpty) {
      for (var row in rows) {
        count = int.parse(row.assoc()['count']!);
        break;
      }
    }
    return count;
  }

  static Future<int> getImpressions(int restaurantID) async {
    int count = 0;
    Mysql db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT views FROM Impressions WHERE restaurant_id = $restaurantID;');
    if (rows.isNotEmpty) {
      for (var row in rows) {
        count = int.parse(row.assoc()['views']!);
        break;
      }
    }
    return count;
  }
}
