/// mainFactory.dart
/// main.dartで使用する関数定義

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
  return _todayDate;
}


/*
Name : GetNextMatch()
Arg  : None
Func : 実行した年月日以降直近で実施される試合のスケジュールを取得
* */
void GetNextMatch() {
  DateTime _todayDate = DateTime.parse(GetTodayDate());
  bool _decidedNextMatch = false;

  sampleList.forEach((v) {
    DateTime databaseTime = DateTime.parse(v[3].toString());
    if (_todayDate.difference(databaseTime).inDays == 0 &&
        _todayDate.day == databaseTime.day) {
      // 今日試合がある場合
      lNextMatch = [...v]; // vの内容をコピー ※dart2.3.0以降
      lNextMatch.add("TODAY'S MATCH");
      _decidedNextMatch = true;
    }
    else if (databaseTime.isAfter(_todayDate)) {
      // 今日以降の日付だった場合
      if (!_decidedNextMatch) {
        lNextMatch = [...v];
        lNextMatch.add('NEXT MATCH');
        _decidedNextMatch = true;
      } else {
        lMatchFromToday.add(v);
      }
    }
    else {
      // 今日より前の日付だった場合
      // No Action
    }
  });
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
