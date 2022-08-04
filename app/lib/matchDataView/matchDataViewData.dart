
//import 'package:judge/mainData.dart';

// 試合情報を格納
//List<cMatchData> lMatchData = [];

// 選手情報を格納
import 'dart:ui';

import 'package:flutter/material.dart';

class CPlayerData {
  CPlayerData(this.name, this.number);
  String name;
  int    number;
}

// Today'sMatch か NextMatchのテキストスタイル
var tsSubmitIcon = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w300,
  fontFamily: 'Roboto',
  letterSpacing: 1.0,
  fontSize: 20.0,
);