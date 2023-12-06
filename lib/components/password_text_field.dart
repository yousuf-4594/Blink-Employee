import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/classes/UiColor.dart';

class PasswordTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChange;
  PasswordTextField({required this.hintText, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: ui.val(2).withOpacity(0.6),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: ui.val(2).withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: this.hintText,
            hintStyle: TextStyle(
              color: ui.val(4).withOpacity(0.5),
            ),
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: ui.val(4).withOpacity(0.5),
            ),
          ),
          onChanged: onChange,
        ),
      ),
    );
  }
}
