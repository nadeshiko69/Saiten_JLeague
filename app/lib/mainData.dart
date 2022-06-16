/// mainData.dart
/// main.dartで使用するdata定義
import 'package:flutter/material.dart';

// ログイン情報
class CMyData {
  CMyData(this.userID, this.email, this.isAlreadyLogin);
  String userID;        // Authで登録したuserID
  String email;         // Authで登録したメアド
  bool isAlreadyLogin;  // 現在ログインしているか
}
CMyData myData = CMyData('','NOT LOGIN', false);

// Firebaseから全試合情報を取得
class CMatchData {
  CMatchData(this.opponent, this.day, this.matchNo);
  String opponent;
  String day;
  int    matchNo;
  String ?nextOrToday;
}
List<CMatchData> lAllMatch = [];

// メインページ上部NextMatchに表示する情報
CMatchData nextMatchData = CMatchData("opponent", "day", -1);
List<CMatchData> lNextMatch = [nextMatchData];

// メインページ下部に表示する今後の試合情報
List lMatchFromToday = [];

// Today'sMatch か NextMatchのテキストスタイル
var tsNextMatchTextStyle = const TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontFamily: 'Roboto',
  letterSpacing: 1.0,
  fontSize: 20.0,
);

var tsScheduleTextStyle = const TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontFamily: 'Roboto',
  letterSpacing: 1.0,
  fontSize: 20.0,
);

var tsOpponentNameTextStyle = const TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w900,
  fontFamily: 'Roboto',
  letterSpacing: 1.0,
  fontSize: 30.0,
);