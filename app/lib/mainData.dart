/// mainData.dart
/// main.dartで使用するdata定義
import 'package:flutter/material.dart';




// メインページ上部NextMatchに表示する情報
List lNextMatch = [];

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