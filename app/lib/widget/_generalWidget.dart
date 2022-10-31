import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Widget_HorizontalBorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[200],
    );
  }
}