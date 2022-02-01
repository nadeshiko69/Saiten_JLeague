
import 'package:judge/mainData.dart';

// 試合情報を格納
List<cMatchData> lMatchData = [];

// 選手情報を格納
class cPlayerData {
  cPlayerData(this.name, this.number);
  String name;
  int    number;
}

// スタメン
List<cPlayerData> lStartingMemberData = [];

// サブ
List<cPlayerData> lSubMemberData = [];



