import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:judge/myPage/Page_myPage.dart';

class Widget_CompleteSubmit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("提出が完了しました"),
      content: const Text("結果発表をお待ちください！"),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class Widget_GoLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("ログインしてください"),
      content: const Text("採点の提出にはログインが必要です。"),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text("ログイン画面へ"),
          onPressed: () =>                   Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CAuthPageView())),
        ),
      ],
    );
  }
}
