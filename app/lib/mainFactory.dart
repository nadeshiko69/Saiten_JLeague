/// mainFactory.dart
/// main.dartで使用する関数定義

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:judge/mainData.dart';

/*
Name : GetTodayDate()
Arg  : None
Func : 実行した年月日をyyyy-MM-ddとして取得
* */
String GetTodayDate() {
  initializeDateFormatting("ja_JP");
  DateTime _now = DateTime.now();
  DateFormat outputFormat = DateFormat('yyyy-MM-dd HHmm', "ja_JP");
  String _todayDate = outputFormat.format(_now); // 今日の年月日を取得
  //print(_todayDate);
  return _todayDate;
}


/*
Name : GetNextMatch()
Arg  : None
Func : 実行した年月日以降直近で実施される試合のスケジュールを取得
* */
void GetNextMatch() async{

  DateTime _todayDate = DateTime.parse(GetTodayDate());
  bool _decidedNextMatch = false;

  final _userCollection = FirebaseFirestore.instance.collection('Nagoya _Schedule');
  final QuerySnapshot snapshot = await _userCollection.get();

  final matchData = snapshot.docs.map((DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final String opponent = data['opponent'];
    final String day = data['day'].toString();
    final int matchNo = data['matchNo'];
    return cMatchData(opponent, day, matchNo);
  }).toList();

  lAllMatch = matchData;
  lAllMatch.sort((a, b) => a.matchNo.compareTo(b.matchNo));

  lAllMatch.forEach((v) {
    //print(v.day);
    DateTime databaseTime = DateTime.parse(v.day);
    if (_todayDate.difference(databaseTime).inDays == 0 &&
        _todayDate.day == databaseTime.day) {
      // 今日試合がある場合
      lNextMatch[0].opponent = v.opponent;
      lNextMatch[0].matchNo  = v.matchNo;
      lNextMatch[0].day      = v.day;
      lNextMatch[0].nextOrToday = "TODAY'S MATCH";
      _decidedNextMatch = true;
    }
    else if (databaseTime.isAfter(_todayDate)) {
      // 今日以降の日付だった場合
      if (!_decidedNextMatch) {
        lNextMatch[0].opponent = v.opponent;
        lNextMatch[0].matchNo  = v.matchNo;
        lNextMatch[0].day      = v.day;
        lNextMatch[0].nextOrToday = "NEXT MATCH";
        _decidedNextMatch = true;
      } else {
        // AllMatch出力する方が良さそうなので、今後も必要なさそうなら削除
        lMatchFromToday.add(v);
      }
    }
    else {
      // 今日より前の日付だった場合
      // No Action
    }
  }
  );
}

/*
ONLY TEST USE
* */
List sampleList = [
  [1, '福岡', 'A', '2021-02-28 1300'],
  [2, '札幌', 'H', '2021-03-06 1600'],
  [3, '柏', 'A', '2021-03-10 1800'],
  [4, '神戸', 'A', '2021-03-13 1800'],
  [5, '横浜FC', 'H', '2022-01-02 1900'],
  [6, '鹿島', 'A', '2022-04-03 1400'],
  [7, 'FC東京', 'H', '2022-04-07 1900'],
  [8, '湘南', 'A', '2022-04-11 1500'],
  [9, '大分', 'A', '2022-04-14 1930'],
  [10, '広島', 'H', '2022-04-18 1500']
];
