import 'package:flutter/material.dart';
import 'package:judge/myPage/login.dart';
import 'package:provider/provider.dart';

// Auth機能 https://www.flutter-study.dev/firebase/authentication

class CMyPageView extends StatelessWidget {
  const CMyPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Page"),
      ),
      body: const MyAuthPage(),
    );
  }
}