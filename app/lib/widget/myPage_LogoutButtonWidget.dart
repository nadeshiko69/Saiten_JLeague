import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:judge/main.dart';
import 'package:judge/mainData.dart';

class Widget_LogoutButton extends StatelessWidget {
  const Widget_LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        myData.isAlreadyLogin = false;
        myData.email = 'NOT LOGIN';
        myData.userID = '';
        Navigator.push(context, MaterialPageRoute(builder: (context) => CMainPage(userID: myData.userID, email: myData.email, isAlreadyLogin: myData.isAlreadyLogin,),));
      },
      child: const Text('logout'),
    );
  }
}