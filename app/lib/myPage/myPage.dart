import 'package:flutter/material.dart';
import 'package:judge/main.dart';
import 'package:judge/matchDataView/matchDataView.dart';
import 'package:judge/mainData.dart';

class CMyPage extends StatelessWidget {
  const CMyPage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      // ログアウトボタン作る
      child: ElevatedButton(
        onPressed: () {
          myData.isAlreadyLogin = false;
          myData.email = 'NOT LOGIN';
          myData.userID = '';
          Navigator.push(context, MaterialPageRoute(builder: (context) => CMainPage(userID: myData.userID, email: myData.email, isAlreadyLogin: myData.isAlreadyLogin,),));
        },
        child: null,
      ),
    );
  }
}
