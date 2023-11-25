import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/classes/order.dart';
import 'package:food_delivery_restraunt/classes/restaurant.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  int loginID = -1;
  Restaurant restaurant;

  HomeScreen({super.key, required this.restaurant});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final itemList = [
    {
      'image': 'assets/icons/cancel.png',
      'title': 'Chicken mayo boti roll',
      'desc': 'priaaa',
    },
    {
      'image': 'assets/icons/cancel.png',
      'title': 'biryani',
      'desc': 'price',
    },
    {
      'image': 'assets/icons/cancel.png',
      'title': 'Item 3',
      'desc': 'price',
    },
    {
      'image': 'assets/icons/cancel.png',
      'title': 'Item 1',
      'desc': 'price',
    },
    {
      'image': 'assets/icons/cancel.png',
      'title': 'Item 2',
      'desc': 'price',
    },
    {
      'image': 'assets/icons/cancel.png',
      'title': 'Item 3',
      'desc': 'price',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                bottomLeft:
                    Radius.circular(20.0), // Adjust the radius as needed
                bottomRight:
                    Radius.circular(20.0), // Adjust the radius as needed
              ),
            ),
            flexibleSpace: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: FlexibleSpaceBar(
                title: Text(
                  widget.restaurant.name,
                  style: TextStyle(
                    fontFamily: 'Britanic',
                    fontSize: 40,
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                background: Stack(
                  children: [
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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 30),
                const ListTile(
                  title: Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ),
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
                                  // Tab(
                                  //   child: Text(
                                  //     'Preparing',
                                  //     style: TextStyle(),
                                  //   ),
                                  // ),
                                  // Tab(
                                  //   child: Text(
                                  //     'Completed',
                                  //     style: TextStyle(),
                                  //   ),
                                  // ),
                                ],
                                labelColor: Color.fromARGB(255, 0, 0, 0),
                                unselectedLabelColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                isScrollable: false,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Color.fromARGB(255, 145, 197, 248),
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
                                    restaurantID:
                                        widget.restaurant.restaurantID,
                                    status: 'all'),
                                // OrderListView(itemList: itemList),
                                // OrderListView(itemList: itemList),
                              ],
                            )),
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
  final int restaurantID;

  const OrderListView(
      {Key? key, required this.status, required this.restaurantID})
      : super(key: key);

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  late List<Order> orders = [];

  void getOrders() async {
    List<Order> tempOrders = await Order.getOrders(widget.restaurantID);
    if (this.mounted) {
      setState(() {
        orders = tempOrders;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      getOrders();
      timer = Timer.periodic(
          const Duration(seconds: 60), (Timer t) => setState(() {}));
    } else {
      timer.cancel();
    }
  }

  late var timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                SlidableAction(
                  onPressed: (context) {
                    setState(() {
                      orders.removeAt(index);
                    });
                  },
                  autoClose: true,
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                ),
                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       itemList.removeAt(index);
                //     });
                //   },
                //   child: Container(
                //     width: 50,
                //     decoration: const BoxDecoration(
                //       color: Colors.amber,
                //     ),
                //     child: Icon(Icons.delete),
                //   ),
                // ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color.fromARGB(132, 0, 0, 0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 0.5,
                      spreadRadius: 0.5,
                      color: Colors.grey[400]!),
                ],
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
                        Text('#${item.orderID}', // order number
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            )),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                              '${item.status}', // supposed to be a button  [Finish | Prepare]
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 25),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(107, 255, 135, 61),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ListView.builder(
                          itemCount: item.orderDetails.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Text('1 x'), // quantity
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                    ),
                                    Text(item.orderDetails[index].name, // item
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                                Text(
                                    'Rs ${item.orderDetails[index].price}', // item price
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    )),
                              ],
                            );
                          })),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.only(
                                right: 25, top: 10, bottom: 10, left: 10),
                            alignment: Alignment.centerRight,
                            child: Text('Rs ${item.price}', // tot price
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ))),
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
  }
}
