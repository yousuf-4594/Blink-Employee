import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _CartScreenState();
}

class Category {
  final String categoryName;
  final List<MenuItem> items;

  Category({required this.categoryName, required this.items});
}

class MenuItem {
  final String image;
  final String title;
  final String price;

  MenuItem({required this.image, required this.title, required this.price});
}

class _CartScreenState extends State<MenuScreen> {
  final itemList = [
    Category(
      categoryName: 'Category 1',
      items: [
        MenuItem(
          image: 'assets/icons/cancel.png',
          title: 'Chicken mayo boti roll',
          price: 'price',
        ),
        MenuItem(
          image: 'assets/icons/cancel.png',
          title: 'Biryani',
          price: '120rs',
        ),
      ],
    ),
    Category(
      categoryName: 'Category 2',
      items: [
        MenuItem(
          image: 'assets/icons/cancel.png',
          title: 'Item 3',
          price: '120rs',
        ),
        MenuItem(
          image: 'assets/icons/cancel.png',
          title: 'Item 1',
          price: '120rs',
        ),
      ],
    ),
    Category(
      categoryName: 'Category 3',
      items: [
        MenuItem(
          image: 'assets/icons/cancel.png',
          title: 'Item 3',
          price: '120rs',
        ),
        MenuItem(
          image: 'assets/icons/cancel.png',
          title: 'Item 1',
          price: '120rs',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
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
                icon: Icon(Icons.api_rounded),
                onPressed: () {},
              ),
              Text(
                'Edit menu',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: itemList.map((category) {
              return CategoryWidget(disp: category);
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

  CategoryWidget({required this.disp});

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool isEditMode = false;
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
        color: Colors.black87,
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
                        color: Colors.white,
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
                  TextEditingController(text: item.price);

              if (isEditMode) {
                return GestureDetector(
                  onTap: () {
                    print(index);

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
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
                                  ),
                                ),
                                SizedBox(height: 32.0),
                                Text("Food Name:"),
                                SizedBox(height: 8.0),
                                TextField(
                                  controller: namecontroller,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Food Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Text("Food Price:"),
                                SizedBox(height: 8.0),
                                TextField(
                                  onTap: () {
                                    pricecontroller.clear();
                                  },
                                  controller: pricecontroller,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Food Price',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 25.0),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(top: 15, bottom: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.amber,
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
                        color: Colors.brown,
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
                            item.price,
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
                            color: Colors.brown,
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
                                item.price,
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
              print('a');
              AddMenuItemBottomSheet(context);
            },
            child: Container(
              width: double.infinity,
              height: 35,
              margin: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Color.fromARGB(80, 255, 255, 255),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    '  Add',
                    style: TextStyle(
                      color: Colors.white,
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

  Future<dynamic> AddMenuItemBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
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
                  widget.disp.categoryName,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32.0),
                Text("Food Name:"),
                SizedBox(height: 8.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Food Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                Text("Food Price:"),
                SizedBox(height: 8.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Food Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 25.0),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.amber,
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
