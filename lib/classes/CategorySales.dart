import 'dart:ui';

class CategorySales {
  final int categoryID;
  final String categoryName;
  final int percentage;
  late Color color;

  CategorySales(
      {required this.categoryID,
      required this.categoryName,
      required this.percentage,
      required this.color});
}
