import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/mysql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery_restraunt/classes/UiColor.dart';
import 'package:flutter/services.dart';

import '../classes/restaurant.dart';

class MenuScreen extends StatefulWidget {
  final Restaurant restaurant;
  const MenuScreen({super.key, required this.restaurant});

  @override
  State<MenuScreen> createState() => _CartScreenState();
}

class Category {
  final int categoryID;
  final String categoryName;
  final List<MenuItem> items;

  Category(
      {required this.categoryName,
      required this.items,
      required this.categoryID});
}

class MenuItem {
  final String image;
  final int productID;
  final String title;
  final int price;

  MenuItem(
      {required this.image,
      required this.title,
      required this.price,
      required this.productID});
}

late List<Category> itemList = [];

class _CartScreenState extends State<MenuScreen> {
  int categoryExists(List<Category> temp, int categoryID) {
    for (int i = 0; i < temp.length; i++) {
      if (temp[i].categoryID == categoryID) {
        return i;
      }
    }
    return -1;
  }

  void getCategory() async {
    List<Category> temp = [];
    var db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT P.product_id, P.name AS p_name, P.price, C.category_id, C.name AS c_name FROM Product P INNER JOIN Category C ON (P.category_id = C.category_id) WHERE P.restaurant_id=${widget.restaurant.restaurantID};');

    for (var row in rows) {
      int index = categoryExists(temp, int.parse(row.assoc()['category_id']!));
      if (index >= 0) {
        temp[index].items.add(MenuItem(
            image: 'images/kfc.jpg',
            title: row.assoc()['p_name']!,
            price: int.parse(row.assoc()['price']!),
            productID: int.parse(row.assoc()['product_id']!)));
      } else {
        temp.add(Category(
            categoryName: row.assoc()['c_name']!,
            items: <MenuItem>[],
            categoryID: int.parse(row.assoc()['category_id']!)));
        int i = categoryExists(temp, int.parse(row.assoc()['category_id']!));
        temp[i].items.add(MenuItem(
            image: 'images/kfc.jpg',
            title: row.assoc()['p_name']!,
            price: int.parse(row.assoc()['price']!),
            productID: int.parse(row.assoc()['product_id']!)));
      }
    }

    setState(() {
      itemList = temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ui.val(0),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: ui.val(0),
            statusBarColor: Colors.black,
          ),
          automaticallyImplyLeading: false,
          title: Text(
            'Dhaba',
            style: TextStyle(
              fontSize: 50,
              fontFamily: 'Britanic',
            ),
          ),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                print("Change vendor name right now");
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.api_rounded,
                  color: ui.val(4),
                ),
                onPressed: () {},
              ),
              Text(
                'Edit menu',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: ui.val(4),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: itemList.map((category) {
              return CategoryWidget(
                disp: category,
                restaurantID: widget.restaurant.restaurantID,
              );
            }).toList(),
          ),
          SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}

class CategoryWidget extends StatefulWidget {
  final Category disp;
  final int restaurantID;

  CategoryWidget({required this.disp, required this.restaurantID});

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool isEditMode = true;
  List<bool> foodSelected = [];

  @override
  Widget build(BuildContext context) {
    if (foodSelected.isEmpty) {
      foodSelected = List.generate(widget.disp.items.length, (index) => false);
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20, left: 5, right: 5),
      decoration: BoxDecoration(
        color: ui.val(1),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.disp.categoryName,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      iconSize: 25,
                      onPressed: () {
                        setState(() {
                          isEditMode = !isEditMode;
                          foodSelected = List.generate(
                              widget.disp.items.length, (index) => false);
                        });
                      },
                      color: Colors.white,
                      icon: Icon(Icons.edit_square),
                    ),
                  ],
                ),
                if (!isEditMode)
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'delete',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 102, 91),
                        fontSize: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 5),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.disp.items.length,
            itemBuilder: (context, index) {
              final item = widget.disp.items[index];

              TextEditingController namecontroller =
                  TextEditingController(text: item.title);
              TextEditingController pricecontroller =
                  TextEditingController(text: '${item.price}');

              if (isEditMode) {
                return GestureDetector(
                  onTap: () {
                    print(index);

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: ui.val(1),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Edit Food item',
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    color: ui.val(4),
                                  ),
                                ),
                                SizedBox(height: 32.0),
                                Text(
                                  "Food Name:",
                                  style: TextStyle(
                                    color: ui.val(4),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                TextField(
                                  controller: namecontroller,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Food Name',
                                    border: OutlineInputBorder(),
                                    hintStyle: TextStyle(
                                      color: ui.val(4),
                                    ),
                                  ),
                                  style: TextStyle(color: ui.val(4)),
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  "Food Price:",
                                  style: TextStyle(
                                    color: ui.val(4),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                TextField(
                                  onTap: () {
                                    pricecontroller.clear();
                                  },
                                  controller: pricecontroller,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Food Price',
                                    border: OutlineInputBorder(),
                                    hintStyle: TextStyle(
                                      color: ui.val(4),
                                    ),
                                  ),
                                  style: TextStyle(color: ui.val(4)),
                                ),
                                SizedBox(height: 25.0),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(top: 15, bottom: 15),
                                    decoration: BoxDecoration(
                                        color: ui.val(9),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    alignment: Alignment.center,
                                    child: Text('Edit'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  onLongPress: () {
                    setState(() {
                      isEditMode = !isEditMode;
                    });
                    print("longpress");
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: ui.val(9).withOpacity(0.6),
                      ),
                      margin: EdgeInsets.only(top: 15.0, right: 5, left: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.only(left: 3, top: 3, bottom: 3),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: ui.val(1),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${item.price}',
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      )),
                );
              } else if (!isEditMode) {
                return Container(
                  margin: EdgeInsets.only(top: 14.0, right: 5, left: 5),
                  child: Container(
                      child: Row(
                    children: [
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor:
                              Colors.white, // Color of the box when unchecked
                          checkboxTheme: CheckboxThemeData(
                            checkColor: MaterialStateColor.resolveWith(
                              (states) => Colors.black,
                            ),
                            mouseCursor: MaterialStateMouseCursor.clickable,
                          ),
                        ),
                        child: Checkbox(
                          value: foodSelected[index],
                          onChanged: (bool? value) {
                            setState(() {
                              foodSelected[index] = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: ui.val(9).withOpacity(0.3),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                margin:
                                    EdgeInsets.only(left: 3, top: 3, bottom: 3),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                item.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '${item.price}',
                                style: TextStyle(
                                  color: Colors.white,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                );
              }
            },
          ),
          GestureDetector(
            onTap: () {
              print('${widget.disp.categoryID}');
              AddMenuItemBottomSheet(
                  context, widget.disp.categoryID, widget.restaurantID);
            },
            child: Container(
              width: double.infinity,
              height: 35,
              margin: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 5),
              decoration: BoxDecoration(
                color: ui.val(10),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+',
                    style: TextStyle(
                      color: ui.val(1),
                      fontWeight: FontWeight.w100,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    '  Add',
                    style: TextStyle(
                      color: ui.val(1),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> AddMenuItemBottomSheet(
      BuildContext context, int categoryID, int restaurantID) {
    String foodName = '';
    int price = -1;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ui.val(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Items to " + widget.disp.categoryName + " category",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: ui.val(4),
                  ),
                ),
                SizedBox(height: 32.0),
                Text(
                  "Food Name:",
                  style: TextStyle(
                    color: ui.val(4),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Food Name',
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(
                      color: ui.val(4),
                    ),
                  ),
                  style: TextStyle(color: ui.val(4)),
                  onChanged: (text) {
                    foodName = text;
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  "Food Price:",
                  style: TextStyle(
                    color: ui.val(4),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Food Price',
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(
                      color: ui.val(4),
                    ),
                  ),
                  style: TextStyle(color: ui.val(4)),
                  onChanged: (text) {
                    try {
                      int p = int.parse(text);
                      price = p;
                    } catch (e) {}
                  },
                ),
                SizedBox(height: 25.0),
                InkWell(
                  onTap: () async {
                    if (foodName.isNotEmpty && price > 0) {
                      var db = Mysql();
                      int productID = await db.addProduct(
                          foodName, restaurantID, categoryID, price);
                      for (int i = 0; i < itemList.length; i++) {
                        if (itemList[i].categoryID == categoryID) {
                          setState(() {
                            itemList[i].items.add(MenuItem(
                                image: 'images/kfc.jpg',
                                title: foodName,
                                price: price,
                                productID: productID));
                          });
                        }
                      }
                      await Future.delayed(const Duration(seconds: 2));
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                        color: ui.val(10),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    alignment: Alignment.center,
                    child: Text('Add to menu'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
