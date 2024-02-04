import 'package:flutter/material.dart';

import 'package:food_delivery_restraunt/classes/UiColor.dart';

class PlainTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Function(String) onChange;
  final TextEditingController controller;
  PlainTextField(
      {required this.hintText,
      required this.onChange,
      required this.controller,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: ui.val(2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          style: TextStyle(
            color: ui.val(4),
          ),
          decoration: InputDecoration(
            hintText: this.hintText,
            labelText: labelText,
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
