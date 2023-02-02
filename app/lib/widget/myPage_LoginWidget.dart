import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/myPage/Page_myPage.dart';

import '../main.dart';

class MyAuthPage extends StatefulWidget {
  const MyAuthPage({Key? key}) : super(key: key);

  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

class _MyAuthPageState extends State<MyAuthPage> {
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // 入力されたメールアドレス（ログイン）
  String loginUserEmail = "";
  // 入力されたパスワード（ログイン）
  String loginUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    loginUserEmail = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "パスワード"),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    loginUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: kColorWidget),
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                    await auth.signInWithEmailAndPassword(
                      email: loginUserEmail,
                      password: loginUserPassword,
                    );
                    // ログインに成功した場合
                    final User user = result.user!;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CMainPage(userID: user.uid, email: user.email.toString(), isAlreadyLogin: true,),));
                    setState(() {
                      infoText = "ログインOK：${user.email}";
                      myData.userID = user.uid;
                      myData.email = user.email.toString();
                      myData.isAlreadyLogin = true;
                    });
                  } catch (e) {
                    // ログインに失敗した場合
                    setState(() {
                      infoText = "ログインNG：${e.toString()}";
                    });
                  }
                },
                child: const Text("ログイン", style: TextStyle(
                  color: kColorBlackText,
                ),),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kColorWidget),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CRegisterPageView()));
                },
                child: const Text("登録はこちら", style: TextStyle(
                  color: kColorBlackText,
                ),),
              ),
              Text(infoText),
            ],
          ),
        ),
      ),
    );
  }
}

