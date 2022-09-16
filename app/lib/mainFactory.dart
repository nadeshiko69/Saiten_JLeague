/// mainFactory.dart
/// main.dartで使用する関数定義

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:judge/mainData.dart';

/*
Name : GetTodayDate()
Arg  : None
Func : 実行した年月日をyyyy-MM-ddとして取得
* */
String fGetTodayDate() {
  initializeDateFormatting("ja_JP");
  DateTime _now = DateTime.now();
  DateFormat outputFormat = DateFormat('yyyy-MM-dd HHmm', "ja_JP");
  String _todayDate = outputFormat.format(_now); // 今日の年月日を取得
  //print(_todayDate);
  return _todayDate;
}


/*
Name : GetNextMatch()
Arg  : String teamName : firebaseに登録してあるチーム名
Func : 実行した年月日以降直近で実施される試合のスケジュールを取得
* */
void fGetNextMatch(String teamName) async{

  DateTime _todayDate = DateTime.parse(fGetTodayDate());
  bool _decidedNextMatch = false;

  final _userCollection = FirebaseFirestore.instance
      .collection('Data2022')
      .doc(teamName)
      .collection('Match');
  final QuerySnapshot snapshot = await _userCollection.get();

  final matchData = snapshot.docs.map((DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    final String matchID = document.id;
    final String day = data['kickoff'].toDate().toString();
    final int matchNo = data['section'];
    String opponent;
    if(data["home"] == fConverseTeamName(teamName)) {
      opponent = data['away'];
    }
    else {
      opponent = data['home'];
    }
    return CMatchData(matchID,opponent, day, matchNo);
  }).toList();

  lAllMatch = matchData;
  lAllMatch.sort((a, b) => a.matchNo.compareTo(b.matchNo));

  for (var v in lAllMatch) {
    DateTime databaseTime = DateTime.parse(v.day);
    if (_todayDate.difference(databaseTime).inDays == 0 &&
        _todayDate.day == databaseTime.day) {
      // 今日試合がある場合
      lNextMatch[0].opponent = v.opponent;
      lNextMatch[0].matchNo  = v.matchNo;
      lNextMatch[0].matchID  = v.matchID;
      lNextMatch[0].day      = v.day;
      lNextMatch[0].nextOrToday = "TODAY'S MATCH";
      _decidedNextMatch = true;
    }
    else if (databaseTime.isAfter(_todayDate)) {
      // 今日以降の日付だった場合
      if (!_decidedNextMatch) {
        lNextMatch[0].opponent = v.opponent;
        lNextMatch[0].matchNo  = v.matchNo;
        lNextMatch[0].matchID  = v.matchID;
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
}

/*
Name : fConverseTeamName()
Arg  : String teamName : firebaseに登録してあるチーム名
Func : firebaseのチーム名を漢字表記に直す（HOME／AWAY判定で使用）
Todo : 他チーム実装したらcaseを追加する
* */
String fConverseTeamName(String teamName){
  String ret;
  switch(teamName){
    case 'Nagoya': ret = "名古屋"; break;
    default : ret = "Abnormal case";
  }
  return ret;
}