import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/components/setting_switch.dart';
import 'package:food_delivery_restraunt/components/title_button.dart';
import 'package:flutter/services.dart';
import '../classes/restaurant.dart';
import '../graphs/barGraphDoubleLines.dart';
import 'package:food_delivery_restraunt/classes/UIColor.dart';
import '../graphs/piChart.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';
  final Restaurant restaurant;
  const SettingsScreen({super.key, required this.restaurant});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

/*
User settings options
Profile settings (Name/password)
  |----> password changing ke liye email verification?
App theme Dark/Light/SystemSettings
Notification preferences Turn ON OFF
stored billing information Add/Remove/Delete
view past orders
  |----> view us order ki detail
Terms of service and privacy policy
App version information
FAQs
Feedback Form
*/

class _SettingsScreenState extends State<SettingsScreen> {
  bool light = true;
  late String name = '';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 44, 44, 44),
    ));
    return Container(
      decoration: BoxDecoration(
        color: ui.val(0),
      ),
      child: ListView(
        children: [
          Header(
            name: widget.restaurant.name,
          ),
          const SizedBox(height: 30.0),
          Divider(color: Colors.transparent, thickness: 2),
          SettingSwitch(
            primaryTitle: 'Dark Mode',
            secondaryTitle: 'Turn on dark mode',
            switchValue: true,
          ),
          Divider(color: Colors.transparent, thickness: 2),
          SettingSwitch(
            primaryTitle: 'Push notifications',
            secondaryTitle: 'Turn on to get notified on each ',
            switchValue: false,
          ),
          Divider(color: Colors.transparent, thickness: 2),
          TitleButton(
            title: "FAQs",
            subtitle: "Answer to your frequently asked questions",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.transparent, thickness: 2),
          TitleButton(
            title: "Contact Us",
            subtitle: "Chat with our customer support panel",
            onPressed: () {},
          ),
          Divider(color: Colors.transparent, thickness: 2),
          TitleButton(
            title: "Privacy support",
            subtitle: "Agree to terms and conditions",
            onPressed: () {},
          ),
          Divider(color: Colors.transparent, thickness: 2),
          TitleButton(
            title: "Billing",
            subtitle: "Add/delete billing information",
            onPressed: () {},
          ),
          Divider(color: Colors.transparent, thickness: 2),
          SizedBox(
            height: 50,
          ),
          Container(
            width: 4,
            height: 40,
            padding: EdgeInsets.only(left: 18, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: ui.val(10),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                  child: Text(
                'Logout',
                style: TextStyle(color: ui.val(0), fontWeight: FontWeight.bold),
              )),
            ),
          )
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String name;
  const Header({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 210,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 44, 44, 44),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 38, 38, 38),
            borderRadius:
                BorderRadius.vertical(top: Radius.elliptical(190, 100)),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 29, 29, 29),
            borderRadius:
                BorderRadius.vertical(top: Radius.elliptical(210, 100)),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
            color: ui.val(0),
            borderRadius:
                BorderRadius.vertical(top: Radius.elliptical(230, 100)),
          ),
        ),
        Positioned(
          top: 70,
          left: (MediaQuery.of(context).size.width / 2) - 50,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.black38, width: 2),
            ),
            child: ClipOval(
              child: Opacity(
                opacity: 0.75,
                child: Image.asset(
                  'assets/icons/profileIcon.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
