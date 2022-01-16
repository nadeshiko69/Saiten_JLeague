/// mainData.dart
/// main.dartで使用するdata定義
import 'package:flutter/material.dart';

// Firebaseから全試合情報を取得
class cMatchData {
  cMatchData(this.opponent, this.day, this.matchNo);
  String opponent;
  String day;
  int    matchNo;
  String ?nextOrToday;
}
List<cMatchData> lAllMatch = [];

// メインページ上部NextMatchに表示する情報
cMatchData nextMatchData = cMatchData("opponent", "day", -1);
List<cMatchData> lNextMatch = [nextMatchData];

// メインページ下部に表示する今後の試合情報
List lMatchFromToday = [];

// Today'sMatch か NextMatchのテキストスタイル
var NextMatchTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontFamily: 'Roboto',
  letterSpacing: 1.0,
  fontSize: 20.0,
);

var ScheduleTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontFamily: 'Roboto',
  letterSpacing: 1.0,
  fontSize: 20.0,
);

var OpponentNameTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w900,
  fontFamily: 'Roboto',
  letterSpacing: 1.0,
  fontSize: 30.0,
);