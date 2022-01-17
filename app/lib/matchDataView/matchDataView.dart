import 'package:flutter/material.dart';

class cMatchDetailView extends StatelessWidget {
  cMatchDetailView(this.matchNo);
  int matchNo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(matchNo.toString()),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.red,
      ),
    );
  }
}