/// mainData.dart
/// main.dartで使用するdata定義
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Firebaseのアクセス情報
//const Data20XX = 'Data2023';
const Data20XX = 'Data2022'; // FOR TEST



const kColorWidget = Colors.white54;
const kColorText = Color(0xFF9E9E9E);
const kColorBlackText = Color(0xFF212121);
const kColorWhiteText = Color(0xFFE0E0E0);
const kColorRedText = Color(0xFFF44336);
const kColorGold = Color(0xFFC1B695);
const kColorBorder = Color(0xFFE0E0E0);

DateFormat outputDateFormat = DateFormat('yyyy/MM/dd HH:mm');

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
  CMatchData(this.matchID, this.opponent, this.day, this.matchNo, this.stadium);
  String matchID;
  String opponent;
  DateTime day;
  int    matchNo;
  String stadium;
  String nextOrToday = "";
}
List<CMatchData> lAllMatch = []..length = 0;

class CPersonalData {
  CPersonalData(this.name, this.number, this.position, this.averageScore);
  String name;
  int number;
  String position;
  double averageScore;
}

// メインページ上部NextMatchに表示する情報
CMatchData nextMatchData = CMatchData("","opponent", DateTime(1900, 1, 1, 0, 0), -1, "");

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