import 'package:flutter/material.dart';
import 'package:judge/inputScore/Factory_inputScore.dart';
import 'package:judge/myPage/Factory_myPage.dart';
import 'package:judge/myPage/login.dart';

// Auth機能 https://www.flutter-study.dev/firebase/authentication

// 登録画面
class CAuthPageView extends StatelessWidget {
  const CAuthPageView({Key? key}) : super(key: key);

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

// マイページ
class CMyPageView extends StatelessWidget {
  const CMyPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fGetMyInputScore("Nagoya"),
        builder:
            (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 通信中
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.error != null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<String>? lAlreadyInputedMatch = snapshot.data; // 描画用

          // まだメンバー登録していない時にアクセスされた場合のWarningを表示
          if (lAlreadyInputedMatch!.isEmpty) {
            return Center(
              child: Column(
                children: const [
                  Text("No Data."),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text("My Page"),
            ),
            body: Container(),
          );
        });
  }
}
