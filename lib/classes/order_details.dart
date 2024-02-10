/*
  This class describes the each food item inside an order
  Hence name comes order details 
*/
class OrderDetails {
  final String name;
  final int quantity;
  final int price;

  OrderDetails(
      {required this.name, required this.quantity, required this.price});
}
