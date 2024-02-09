import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery_restraunt/services/navigator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:food_delivery_restraunt/components/plain_text_field.dart';
import 'package:food_delivery_restraunt/components/password_text_field.dart';
import 'package:food_delivery_restraunt/components/large_button.dart';
import 'package:food_delivery_restraunt/components/bottom_container.dart';
import 'package:food_delivery_restraunt/mysql.dart';
import 'package:food_delivery_restraunt/user.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery_restraunt/classes/restaurant.dart';
import 'package:food_delivery_restraunt/arguments/home_screen_arguments.dart';
import 'package:food_delivery_restraunt/classes/UiColor.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var username;
  late String ownerName;
  List<Restaurant> restaurants = [];
  var password;
  bool loginValid = true;
  String loginFailedMessage = '';
  late int loginID;
  late String restaurantName;

  Widget buildBottomSheet(BuildContext context) {
    return BottomContainer();
  }

  var db = Mysql();

  Future<bool> _login(String username, String password) async {
    // var conn = await db.getConnection();
    // await conn.connect();
    // var results = await conn.execute(
    //     'SELECT * FROM Customer WHERE username="$username" AND password="$password";');
    // conn.close();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT * FROM Restaurant R INNER JOIN RestaurantAccount A ON (R.username = A.username) WHERE R.username="$username" AND A.password="$password";');
    if (rows.length == 1) {
      for (var row in rows) {
        loginID = int.parse(row.assoc()['restaurant_id']!);
        restaurantName = row.assoc()['name']!;
        ownerName = row.assoc()['owner_name']!;
      }
      return true;
    } else {
      return false;
    }
  }

  void getRestaurants() async {
    Iterable<ResultSetRow> rows = await db
        .getResults('SELECT restaurant_id, name, owner_name FROM Restaurant;');
    for (var row in rows) {
      restaurants.add(Restaurant(
          restaurantID: int.parse(row.assoc()['restaurant_id']!),
          name: row.assoc()['name']!,
          ownerName: row.assoc()['owner_name']!));
    }
  }

  late TextEditingController _usernameTextController;
  late TextEditingController _passwordTextController;

  void getSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
      password = prefs.getString('password')!;
      print("username " + username);
      print("password " + password);
    });
  }

  Future<String?> getUsername() async {
    SharedPreferences signPrefs = await SharedPreferences.getInstance();
    username = signPrefs.get('username2');
    return username;
  }

  Future<String?> getPassword() async {
    SharedPreferences signPrefs = await SharedPreferences.getInstance();
    password = signPrefs.get('password2');
    return password;
  }

  @override
  void initState() {
    super.initState();
    _usernameTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    initializeTextControllers();
  }

  Future<void> initializeTextControllers() async {
    _usernameTextController.text = await getUsername() ?? '';
    _passwordTextController.text = await getPassword() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: ui.val(0),
      statusBarColor: ui.val(0),
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ui.val(0),
      body: SafeArea(
        child: Form(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Hello Again!',
                      textAlign: TextAlign.center,
                      textStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: ui.val(4),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Welcome back, you\'ve been missed',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: ui.val(4),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                PlainTextField(
                  hintText: 'Enter Username',
                  onChange: (text) {
                    username = text;
                  },
                  labelText: 'Username',
                  controller: _usernameTextController,
                ),
                SizedBox(
                  height: 25,
                ),
                PasswordTextField(
                  hintText: 'Enter Password',
                  onChange: (text) {
                    password = text;
                  },
                  controller: _passwordTextController,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  loginFailedMessage,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Text(
                    'Forgot Password',
                    textAlign: TextAlign.end,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: ui.val(4).withOpacity(0.3),
                      ),
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context, builder: buildBottomSheet);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                LargeButton(
                  onPressed: () async {
                    if (await _login(username, password)) {
                      setState(() {
                        loginFailedMessage = '';
                      });
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('username2', username);
                      await prefs.setString('password2', password);
                      getRestaurants();
                      Restaurant restaurant = Restaurant(
                          restaurantID: loginID,
                          name: restaurantName,
                          ownerName: ownerName);
                      Navigator.pushNamed(context, MainNavigator.id,
                          arguments:
                              HomeScreenArguments(restaurant: restaurant));
                    } else {
                      setState(
                        () {
                          loginFailedMessage = 'Invalid username or password';
                        },
                      );
                    }
                  },
                  color: ui.val(10),
                  verticalPadding: 15,
                  buttonChild: Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: ui.val(1),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 55,
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Divider(),
                //     ),
                //     SizedBox(
                //       width: 15,
                //     ),
                //     Text(
                //       "or continue with",
                //     ),
                //     SizedBox(
                //       width: 15,
                //     ),
                //     Expanded(
                //       child: Divider(),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                LargeButton(
                  onPressed: () {},
                  color: ui.val(1).withOpacity(0.3),
                  verticalPadding: 10,
                  buttonChild: Image.asset(
                    'images/google.png',
                    height: 40,
                    color: ui.val(4).withOpacity(0.5),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
