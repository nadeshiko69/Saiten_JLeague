/// mainFactory.dart
/// main.dartで使用する関数定義

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:judge/mainData.dart';

/*
Name : GetNextMatch()
Arg  : String teamName : firebaseに登録してあるチーム名
Func : 実行した年月日以降直近で実施される試合のスケジュールを取得
* */
Future<void> fGetNextMatch(String teamName) async{

  DateTime todayDate = DateTime.now();

  final userCollection = FirebaseFirestore.instance
      .collection(Data20XX)
      .doc(teamName)
      .collection('Match');
  final QuerySnapshot snapshot = await userCollection.get();

  final matchData = snapshot.docs.map((DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    final String matchID = document.id;
    final DateTime day = data['kickoff'].toDate();
    final int matchNo = data['section'];
    final String stadium = data["stadium"];
    String opponent;
    if(data["home"] == fConverseTeamName(teamName)) {
      opponent = data['away'];
    }
    else {
      opponent = data['home'];
    }
    return CMatchData(matchID,opponent, day, matchNo, stadium);
  }).toList();
  // Main画面のリスト
  lAllMatch = matchData;


  // Next Matchの決定
  lAllMatch.sort((a, b) => a.day.compareTo(b.day));
  for (var v in lAllMatch) {
    DateTime kickoffTime = v.day; // 試合開始時間
    DateTime timeupTime = kickoffTime.add(const Duration(hours: 2)); // 試合終了時間
    if(todayDate.isAfter(timeupTime)){ // 試合が行われた後
      if(todayDate.difference(kickoffTime).inDays < 2){ // 2日以内なら採点受付
        nextMatchData.opponent = v.opponent;
        nextMatchData.matchNo  = v.matchNo;
        nextMatchData.matchID  = v.matchID;
        nextMatchData.day      = v.day;
        nextMatchData.nextOrToday = "ACCEPTING INPUT";
        break;
      }
      else { // それより前ならすでに結果発表済み
        /* No Action */
      }
    }
    else { // 試合前
      if(todayDate.difference(kickoffTime).inDays == 0 && todayDate.day == kickoffTime.day){ // 試合開催日
            nextMatchData.opponent = v.opponent;
            nextMatchData.matchNo  = v.matchNo;
            nextMatchData.matchID  = v.matchID;
            nextMatchData.day      = v.day;
            nextMatchData.nextOrToday = "TODAY'S MATCH";
            break;
      }
      else{ // 試合前日より前
            // Next Matchを出力 = 確認対象日が後
            nextMatchData.opponent = v.opponent;
            nextMatchData.matchNo = v.matchNo;
            nextMatchData.matchID = v.matchID;
            nextMatchData.day = v.day;
            nextMatchData.nextOrToday = "NEXT MATCH";
            break;
      }
    }
  }
  lAllMatch.sort((a, b) => a.matchNo.compareTo(b.matchNo));
}

/*
Name : fConverseTeamName()
Arg  : String teamName : firebaseに登録してあるチーム名
Func : firebaseのチーム名を漢字表記に直す（HOME／AWAY判定で使用）
* */
String fConverseTeamName(String teamName){
  String ret;
  switch(teamName){
    case 'Nagoya': ret = "名古屋"; break;
    case 'YokohamaFM' : ret = "横浜FM"; break;
    case 'Kawasaki' : ret = "川崎"; break;
    case 'Hiroshima' : ret = "広島"; break;
    case 'COsaka' : ret = "C大阪"; break;
    case 'FCTokyo' : ret = "FC東京"; break;
    case 'Kashima' : ret = "鹿島"; break;
    case 'Kashiwa' : ret = "柏"; break;
    case 'Urawa' : ret = "浦和"; break;
    case 'Tosu' : ret = "鳥栖"; break;
    case 'Kobe' : ret = "神戸"; break;
    case 'Sapporo' : ret = "札幌"; break;
    case 'Shonan' : ret = "湘南"; break;
    case 'Kyoto' : ret = "京都"; break;
    case 'Fukuoka' : ret = "福岡"; break;
    case 'Nigata' : ret = "新潟"; break;
    case 'GOsaka' : ret = "G大阪"; break;
    case 'YokohamaC' : ret = "横浜FC"; break;
    default : ret = "Abnormal case"; break;
  }
  return ret;
}

String fConverseTeamName_ToEngName(String teamName){
  String ret;
  switch(teamName){
    case "名古屋": ret = 'Nagoya'; break;
    case "横浜FM": ret = 'YokohamaFM'; break;
    case "川崎" : ret = 'Kawasaki'; break;
    case "広島": ret = 'Hiroshima'; break;
    case "C大阪": ret = 'COsaka'; break;
    case "FC東京" : ret = 'FCTokyo'; break;
    case "鹿島" : ret = 'Kashima'; break;
    case "柏" : ret = 'Kashiwa'; break;
    case "浦和" : ret = 'Urawa'; break;
    case "鳥栖" : ret = 'Tosu'; break;
    case "神戸" : ret = 'Kobe'; break;
    case "札幌" : ret = 'Sapporo'; break;
    case "湘南" : ret = 'Shonan'; break;
    case "京都" : ret = 'Kyoto'; break;
    case "福岡" : ret = 'Fukuoka'; break;
    case "新潟" : ret = 'Nigata'; break;
    case "G大阪" : ret = 'GOsaka'; break;
    case "横浜FC" : ret = 'YokohamaC'; break;
    default : ret = "Abnormal case"; break;
  }
  return ret;
}