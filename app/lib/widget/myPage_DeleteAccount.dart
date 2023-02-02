// アカウント削除がないとAppleに怒られる
// https://zenn.dev/joo_hashi/articles/4c601640c64c4c

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:judge/main.dart';
import 'package:judge/mainData.dart';
import 'package:judge/widget/myPage_LoginWidget.dart';

class DeleteUserPage extends StatefulWidget {
  DeleteUserPage({Key? key}) : super(key: key);

  @override
  State<DeleteUserPage> createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: kColorWidget,
        iconTheme: const IconThemeData(color: kColorBlackText),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kColorWidget),
                onPressed: () async {
                  final String? selectedText = await showDialog<String>(
                      context: context,
                      builder: (_) {
                        return Widgete_DeleteFirebaseAuthInfo();
                      });
                  print('ユーザーを削除しました!');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CMainPage(
                                userID: "",
                                email: "",
                                isAlreadyLogin: false,
                              )));
                },
                child: const Text('ユーザーを削除',style: TextStyle(
                  color: kColorBlackText,
                )),),
          ],
        ),
      ),
    );
  }
}

class Widgete_DeleteFirebaseAuthInfo extends StatefulWidget {
  Widgete_DeleteFirebaseAuthInfo({Key? key}) : super(key: key);

  @override
  State<Widgete_DeleteFirebaseAuthInfo> createState() =>
      _Widgete_DeleteFirebaseAuthInfoState();
}

class _Widgete_DeleteFirebaseAuthInfoState
    extends State<Widgete_DeleteFirebaseAuthInfo> {
  void deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    // ユーザーを削除
    await user?.delete();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('退会してもよろしいですか?'),
      children: [
        SimpleDialogOption(
          child: const Text('退会する'),
          onPressed: () async {
            deleteUser();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CMyApp()));
          },
        ),
        SimpleDialogOption(
          child: const Text('退会しない'),
          onPressed: () {
            Navigator.pop(
                context, MaterialPageRoute(builder: (context) => MyAuthPage()));
          },
        )
      ],
    );
  }
}
