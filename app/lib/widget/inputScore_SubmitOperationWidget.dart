import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:judge/inputScore/Factory_inputScore.dart';
import 'package:judge/myPage/Page_myPage.dart';
import 'package:judge/widget/_generalWidget.dart';

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
        Widget_TwitterShare(
          text: fGetMyMVP()!,
          hashtags: const [],
          via: "Judge_appInfo",
        ),
      ],
    );
  }
}

class Widget_SubmitTimeOver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("提出に失敗しました"),
      content: const Text("提出可能期間を確認してください。"),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class Widget_PromptSubScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("ベンチメンバーの採点をお願いします"),
      content: const Text("出場無しメンバーはデフォルト値でOKです"),
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
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CAuthPageView())),
        ),
      ],
    );
  }
}
