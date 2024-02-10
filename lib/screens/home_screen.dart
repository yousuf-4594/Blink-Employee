import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/api/firebase_api.dart';
import 'package:food_delivery_restraunt/classes/order.dart';
import 'package:food_delivery_restraunt/classes/restaurant.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:food_delivery_restraunt/classes/UiColor.dart';
import 'package:http/http.dart' as http;

import 'package:food_delivery_restraunt/mysql.dart';

import '../classes/globals.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  int loginID = -1;

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  late Restaurant restaurant = Restaurant(
      restaurantID: "restaurantID", name: "name", ownerName: 'ownername');

  void getRestaurant() async {
    Restaurant temp = await Restaurant.getCurrentRestaurant();
    setState(() {
      restaurant = temp;
    });
  }

  @override
  void initState() {
    if (restaurant.name == "name") {
      getRestaurant();
    }

    super.initState();

    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ui.val(0),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 300.0,
            pinned: true,
            stretch: true,
            centerTitle: false,
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            flexibleSpace: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: FlexibleSpaceBar(
                // Homepage restaurant Title
                title: Text(
                  Global.restaurant.name,
                  style: TextStyle(
                    fontFamily: 'Britanic',
                    fontSize: 40,
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                background: Stack(
                  children: [
                    // Homepage restaurant background image
                    Image.asset(
                      'images/kfc.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.person_outline_rounded),
                onPressed: () {
                  // Open profile screen
                },
              ),
            ],
          ),

          /*
            Sliver list represents entire body below the sliver header
          */
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 30),
                ListTile(
                  title: Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: 50,
                      color: ui.val(4),
                    ),
                  ),
                ),

                /*
                  Tab controller Allows to switch between
                  - All orders
                  - completed orders
                  - pending orders
                */
                DefaultTabController(
                  length: 1,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color.fromARGB(248, 68, 68, 68),
                              ),
                              child: TabBar(
                                tabs: [
                                  Tab(
                                    child: Text(
                                      'All',
                                      style: TextStyle(),
                                    ),
                                  ),
                                ],
                                dividerColor: Colors.transparent,
                                labelColor: Color.fromARGB(255, 0, 0, 0),
                                unselectedLabelColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                isScrollable: false,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ui.val(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: double.maxFinite,
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            return true;
                          },
                          child: TabBarView(
                            children: [
                              OrderListView(
                                restaurantID: restaurant.restaurantID,
                                restaurantName: restaurant.name,
                                status: 'all',
                                notificationServices: notificationServices,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OrderListView extends StatefulWidget {
  final String status;
  final String restaurantID;
  final String restaurantName;
  final NotificationServices notificationServices;

  const OrderListView({
    Key? key,
    required this.status,
    required this.restaurantID,
    required this.restaurantName,
    required this.notificationServices,
  }) : super(key: key);

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  late Stream<List<Order>> ordersStream;

  @override
  void initState() {
    super.initState();
    ordersStream = Order.getRealTimeOrders(widget.restaurantID);
  }

  /*
    Displays list of restaurant orders
  */
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Order>>(
      stream: ordersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 50,
            child: CircularProgressIndicator(
              color: Colors.white70,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            margin: EdgeInsets.only(top: 30),
            width: MediaQuery.of(context).size.width,
            alignment: AlignmentDirectional.topCenter,
            child: Text(
              'No orders available',
              style: TextStyle(
                fontSize: 15,
                color: ui.val(4).withOpacity(0.6),
              ),
            ),
          );
        }

        List<Order> orders = snapshot.data!;
        print(orders);
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final item = orders[index];
            return Padding(
              padding: (index == 0)
                  ? const EdgeInsets.symmetric(vertical: 10.0)
                  : const EdgeInsets.only(bottom: 10.0),
              child: Slidable(
                key: Key('$item'),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    // Slidable Delete button
                    orders[index].status == 'pending'
                        ? SlidableAction(
                            onPressed: (context) {
                              Order.updateStatus(
                                  orders[index].orderID, 'deleted');

                              // setState(() {
                              //   orders.removeAt(index);
                              // });
                            },
                            autoClose: true,
                            borderRadius: BorderRadius.circular(20),
                            backgroundColor: Color.fromARGB(255, 255, 97, 86),
                            icon: Icons.delete,
                            foregroundColor: ui.val(0),
                          )
                        : Container(),
                    SizedBox(width: 2),

                    // Slidable completed button
                    orders[index].status == 'pending'
                        ? SlidableAction(
                            onPressed: (context) {
                              Order.updateStatus(
                                  orders[index].orderID, 'processing');
                            },
                            autoClose: true,
                            borderRadius: BorderRadius.circular(20),
                            backgroundColor:
                                const Color.fromARGB(255, 110, 255, 114),
                            icon: Icons.add,
                          )
                        : SlidableAction(
                            onPressed: (context) {
                              Order.updateStatus(
                                  orders[index].orderID, 'completed');

                              print(
                                  "order completed: ${orders[index].customerID}");
                              print("   ${widget.restaurantID}");
                              print("   ${widget.restaurantName}");
                              firestore.DocumentReference customerRef =
                                  firestore.FirebaseFirestore.instance
                                      .collection('customers')
                                      .doc(orders[index].customerID);

                              // Get the customer document data
                              customerRef.get().then((customerSnapshot) {
                                if (customerSnapshot.exists) {
                                  // Extract the FCM token from the customer document
                                  String? fcmToken = (customerSnapshot.data()
                                      as Map<String, dynamic>?)?['fcmToken'];

                                  // Check if fcmToken is not null before using it
                                  if (fcmToken != null) {
                                    // Update the review and other fields
                                    customerRef.update({
                                      'Placed Order': false,
                                      'Review.Placed': false,
                                      'Review.Restaurant ID':
                                          "eWjuiXzb15xfWxNnEZai", // sufiyaan idhr dekho
                                      'Review.Restaurant Name':
                                          widget.restaurantName,
                                    }).then((value) {
                                      print('Review updated successfully');

                                      // Use the FCM token for further processing
                                      print('FCM Token: $fcmToken');

                                      widget.notificationServices
                                          .getDeviceToken()
                                          .then((value) async {
                                        var data = {
                                          'to': fcmToken,
                                          'priority': 'high',
                                          'notification': {
                                            'title': 'Order completed',
                                            'body':
                                                'Your Order of Rs.${orders[index].price} has been successfully completed and is now ready for pickup.',
                                          },
                                          'android': {
                                            'notification': {
                                              'notification_count': 23,
                                            },
                                          },
                                          'data': {'type': 'msj', 'id': 'Blink'}
                                        };

                                        await http.post(
                                            Uri.parse(
                                                'https://fcm.googleapis.com/fcm/send'),
                                            body: jsonEncode(data),
                                            headers: {
                                              'Content-Type':
                                                  'application/json; charset=UTF-8',
                                              'Authorization':
                                                  'key=AAAASf-EVnA:APA91bEIQRrSlWG6ZsqN5PopS9v36DgfkU8hRtZTeqB3UtGpaoK2qL9-R-hZC1I-GKKel0A1qsrDkZiyjZCDwjlQNqIwEHOUt-GnVWfAXJVTodBv2vZMeZTp8aVchQxZZwfFXONoQby8'
                                            }).then((value) {
                                          if (kDebugMode) {
                                            print(value.body.toString());
                                          }
                                        }).onError((error, stackTrace) {
                                          if (kDebugMode) {
                                            print(error);
                                          }
                                        });
                                      });
                                    }).catchError((error) {
                                      print('Error updating review: $error');
                                    });
                                  } else {
                                    print('FCM Token is null');
                                  }
                                } else {
                                  print('Customer document does not exist');
                                }
                              }).catchError((error) {
                                print('Error fetching customer data: $error');
                              });
                            },
                            autoClose: true,
                            borderRadius: BorderRadius.circular(20),
                            backgroundColor:
                                const Color.fromARGB(255, 110, 255, 114),
                            icon: Icons.add,
                          ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: ui.val(1),
                  ),
                  // ListView row
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '#${item.orderID}', // order number
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            if (orders[index].status == 'pending')
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: ui.val(10).withOpacity(0.85),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(
                                  '${item.status}', // supposed to be a button  [Finish | Prepare]
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: ui.val(1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            if (orders[index].status == 'processing')
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(
                                  '${item.status}', // supposed to be a button  [Finish | Prepare]
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: ui.val(1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 25),
                        decoration: BoxDecoration(
                          color: ui.val(2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: item.orderDetails.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          '${item.orderDetails[index].quantity} x',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ), // quantity
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.only(
                                            top: 3, right: 5, bottom: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                      ),
                                      Text(
                                        item.orderDetails[index].name, // item
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Rs ${item.orderDetails[index].price}', // item price
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                  right: 25, top: 10, bottom: 10, left: 10),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Rs ${item.price}', // tot price
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
