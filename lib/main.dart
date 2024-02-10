import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/services/navigator.dart';
import 'package:food_delivery_restraunt/screens/login_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(FoodDelivery());
}

class FoodDelivery extends StatelessWidget {
  const FoodDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade900,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),

      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        MainNavigator.id: (context) => MainNavigator(),
        // HomeScreen.id: (context) => HomeScreen(loginID: -1),
        // RestaurantScreen.id: (context) => RestaurantScreen(),
        // SettingsScreen.id: (context) => SettingsScreen(),
      },
      // home: MainNavigator(),
      // home: OnboardingScreen(),
    );
  }
}
