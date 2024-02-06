// import 'dart:js_util';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/mysql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery_restraunt/classes/UiColor.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/restaurant.dart';

/*
    Represents Edit menu bottom navigation screen
    here we can add / delete / update menu items from database

*/
// a global key is assigned to our parent scaffold to allow snackbars to be displayed within its context
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void snackbar(String content) {
  ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 1),
      content: Text(content),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Code to execute.
        },
      ),
    ),
  );
}

class MenuScreen extends StatefulWidget {
  final Restaurant restaurant;
  const MenuScreen({super.key, required this.restaurant});

  @override
  State<MenuScreen> createState() => _CartScreenState();
}

// Each category object has many MenuItem objects
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
  final String productID;
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
  int categoryExists(List<Category> temp, String categoryName) {
    for (int i = 0; i < temp.length; i++) {
      if (temp[i].categoryName == categoryName) {
        return i;
      }
    }
    return -1;
  }

  /*
      This function fetches values from:
      restaurants collection and searches in logged in this restaurant's document
      restaurant's document ka sub collection is searched and every food product's document is fetched
      the retrieved values are organized asper the class structure:
        category1
          |_ food item1
          |_ food item2

        category2
          |_ food item1
          |_ food item2
  */

  void getCategory() async {
    List<Category> temp = [];

    try {
      // Reference to the "restaurant" document for the specific restaurant
      DocumentReference restaurantDocumentRef = FirebaseFirestore.instance
          .collection('restaurants')
          .doc("eWjuiXzb15xfWxNnEZai"); // Replace with the actual restaurant ID

      // Reference to the "foodItems" subcollection inside the restaurant document
      CollectionReference foodItemsCollection =
          restaurantDocumentRef.collection('foodItems');

      // Get documents from the "foodItems" subcollection
      QuerySnapshot foodItemsSnapshot = await foodItemsCollection.get();

      // Iterate through each food item document
      for (QueryDocumentSnapshot foodItemDocument in foodItemsSnapshot.docs) {
        Map<String, dynamic> foodItemData =
            foodItemDocument.data() as Map<String, dynamic>;

        String categoryName = foodItemData['Category Name'];

        int index = categoryExists(temp, categoryName);
        if (index >= 0) {
          temp[index].items.add(MenuItem(
                image: 'images/kfc.jpg',
                title: foodItemData['Prod Name'],
                price: foodItemData['Price'],
                productID: foodItemDocument.id,
              ));
        } else {
          temp.add(Category(
            categoryID: 100,
            categoryName: categoryName,
            items: <MenuItem>[
              MenuItem(
                image: 'images/kfc.jpg',
                title: foodItemData['Prod Name'],
                price: foodItemData['Price'],
                productID: foodItemDocument.id,
              ),
            ],
          ));
        }
      }

      setState(() {
        itemList = temp;
      });
    } catch (error) {
      print('Error fetching data: $error');
      // Handle the error as needed
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ui.val(0),

      // app bar on top
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

      // list view body
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('restaurants')
            .doc(
                "eWjuiXzb15xfWxNnEZai") // will replace with the actual restaurant ID
            .collection('foodItems')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white70,
            ));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<Category> temp = [];

          snapshot.data!.docs.forEach((foodItemDocument) {
            Map<String, dynamic> foodItemData =
                foodItemDocument.data() as Map<String, dynamic>;

            String categoryName = foodItemData['Category Name'];

            int index = categoryExists(temp, categoryName);
            if (index >= 0) {
              temp[index].items.add(MenuItem(
                    image: 'images/kfc.jpg',
                    title: foodItemData['Prod Name'],
                    price: foodItemData['Price'],
                    productID: foodItemDocument.id,
                  ));
            } else {
              temp.add(Category(
                categoryID: 100,
                categoryName: categoryName,
                items: <MenuItem>[
                  MenuItem(
                    image: 'images/kfc.jpg',
                    title: foodItemData['Prod Name'],
                    price: foodItemData['Price'],
                    productID: foodItemDocument.id,
                  ),
                ],
              ));
            }
          });

          itemList = temp;

          return ListView(
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

              // the rest of the screen displays a list of category widgets
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
          );
        },
      ),
    );
  }
}

/*
    Updates the Food name and price in Firebase using productID hash

*/
Future<void> updateFoodItem(String restaurantID, String productId,
    String newProdName, int newPrice) async {
  try {
    // Reference to the specific restaurant document using the provided ID
    DocumentReference restaurantDocumentRef =
        FirebaseFirestore.instance.collection('restaurants').doc(restaurantID);

    // Reference to the "foodItems" subcollection inside the restaurant document
    CollectionReference foodItemsCollection =
        restaurantDocumentRef.collection('foodItems');

    // Reference to the specific food item document by product ID
    DocumentReference foodItemDocumentRef = foodItemsCollection.doc(productId);

    // Update the fields in the document
    await foodItemDocumentRef.update({
      'Prod Name': newProdName,
      'Price': newPrice,
    });
    snackbar('Food item updated successfully');
    print('Food item updated successfully!');
  } catch (error) {
    print('Error updating food item: $error');
    snackbar('Error updating food item');
    // Handle the error as needed
  }
}

Future<void> addFoodItem(String restaurantID, String categoryName,
    String prodName, int price, String likeCount) async {
  try {
    // Reference to the "restaurants" collection
    CollectionReference restaurantsCollection =
        FirebaseFirestore.instance.collection('restaurants');

    // Reference to the specific restaurant document
    DocumentReference restaurantDocumentRef =
        restaurantsCollection.doc(restaurantID);

    // Reference to the "foodItems" subcollection inside the restaurant document
    CollectionReference foodItemsCollection =
        restaurantDocumentRef.collection('foodItems');

    // Add a new document with auto-generated ID to the "foodItems" subcollection
    await foodItemsCollection.add({
      'Category Name': categoryName,
      'Prod Name': prodName,
      'Price': price,
      'Like Count': likeCount,
    });

    snackbar('Food item added successfully');
    print('Food item added successfully!');
  } catch (error) {
    print('Error adding food item: $error');
    snackbar('Error adding food item');
  }
}

Future<void> deleteFoodItem(String restaurantID, String foodItemID) async {
  try {
    // Reference to the "restaurants" collection
    CollectionReference restaurantsCollection =
        FirebaseFirestore.instance.collection('restaurants');

    // Reference to the specific restaurant document
    DocumentReference restaurantDocumentRef =
        restaurantsCollection.doc(restaurantID);

    // Reference to the "foodItems" subcollection inside the restaurant document
    CollectionReference foodItemsCollection =
        restaurantDocumentRef.collection('foodItems');

    // Reference to the specific food item document by ID
    DocumentReference foodItemDocumentRef = foodItemsCollection.doc(foodItemID);

    // Delete the document from the "foodItems" subcollection
    await foodItemDocumentRef.delete();

    snackbar('Food item deleted successfully');
    print('Food item deleted successfully!');
  } catch (error) {
    print('Error deleting food item: $error');
    snackbar('Error deleting food item');
  }
}

/*
    Displays the categorical divisions of food items on edit menu
*/
class CategoryWidget extends StatefulWidget {
  final Category disp;
  final int restaurantID;

  CategoryWidget({required this.disp, required this.restaurantID});

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  // edit mode is when checkboxes are displayed
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
                    onPressed: () {
                      for (int i = 0; i < foodSelected.length; i++) {
                        if (foodSelected[i]) {
                          // print(widget.disp.items[i].productID);
                          deleteFoodItem("eWjuiXzb15xfWxNnEZai",
                              widget.disp.items[i].productID);
                        }
                      }
                      // print(foodSelected);
                    },
                    child: Text(
                      'delete',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 102, 91)
                            .withOpacity(0.8),
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
                    // print(index);
                    /*
                      prints Edit food item Bottom Model if 
                      any food item on the menu is clicked
                    */
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
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ui.val(0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ui.val(0)),
                                    ),
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
                                    // pricecontroller.clear();
                                  },
                                  controller: pricecontroller,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Food Price',
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ui.val(0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ui.val(0)),
                                    ),
                                    hintStyle: TextStyle(
                                      color: ui.val(4),
                                    ),
                                  ),
                                  style: TextStyle(color: ui.val(4)),
                                ),
                                SizedBox(height: 25.0),
                                InkWell(
                                  /*
                                      Makes updation operation to database
                                  */
                                  onTap: () {
                                    // print(item.productID);
                                    // print("boom ${pricecontroller.text}");

                                    updateFoodItem(
                                        "eWjuiXzb15xfWxNnEZai",
                                        item.productID,
                                        namecontroller.text,
                                        int.parse(pricecontroller.text));
                                    Navigator.pop(context);
                                  },
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
                            color: ui.val(9).withOpacity(0.5),
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
                          ),
                        ),
                      ),
                    ],
                  )),
                );
              }
            },
          ),

          // Orange add button bottom of every category widget
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

  /*  
      Add menu items to a specific food category 
      pops up bottom modal sheet 
      user may edit menu food items
  */
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
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ui.val(0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ui.val(0)),
                    ),
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
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ui.val(0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ui.val(0)),
                    ),
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
                    addFoodItem("eWjuiXzb15xfWxNnEZai",
                        widget.disp.categoryName, foodName, price, "0");
                    Navigator.pop(context);
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
