import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/classes/order.dart';
import 'package:food_delivery_restraunt/classes/restaurant.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:food_delivery_restraunt/classes/UiColor.dart';

import 'package:food_delivery_restraunt/mysql.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  int loginID = -1;
  Restaurant restaurant;

  HomeScreen({super.key, required this.restaurant});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  widget.restaurant.name,
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
                                labelColor: Color.fromARGB(255, 0, 0, 0),
                                unselectedLabelColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                isScrollable: false,
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
                                restaurantID: widget.restaurant.restaurantID,
                                status: 'all',
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
  final int restaurantID;

  const OrderListView(
      {Key? key, required this.status, required this.restaurantID})
      : super(key: key);

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  late Stream<List<Order>> ordersStream;

  // void getOrders() async {
  //   List<Order> tempOrders = await Order.getPendingOrders(widget.restaurantID);
  //   if (this.mounted) {
  //     setState(() {
  //       orders = tempOrders;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    ordersStream = Order.getRealTimeOrders(widget.restaurantID);
  }

  // late var timer;

  // @override
  // void dispose() {
  //   timer.cancel();
  //   super.dispose();
  // }

  /*
    Displays list of restaurants orders 
  */
  /*
    Displays list of restaurant orders 
  */
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Order>>(
      stream: ordersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or any loading indicator
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No orders available.'));
        }

        List<Order> orders = snapshot.data!;

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

                              // setState(() {
                              //   orders[index].status = 'processing';
                              // });
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
                              // setState(() {
                              //   orders[index].status = 'completed';
                              //   orders.removeAt(index);
                              // });
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
                                            '${item.orderDetails[index].quantity} x'), // quantity
                                        padding: EdgeInsets.all(5),
                                        margin:
                                            EdgeInsets.only(right: 10, top: 5),
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
