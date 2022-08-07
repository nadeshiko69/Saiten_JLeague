/// matchDataViewFactory.dart
/// matchDataView.dartで使用する関数定義

//import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:judge/mainData.dart';
import 'package:judge/matchDataView/matchDataViewData.dart';

/*
Name : fGetMatchMember()
Arg  : teamName, matchNo : 対象チーム、節
     : isStarting : スタメン or ベンチ / trueならスタメン, falseならベンチ
Func : 該当する試合の登録メンバーを取得
* */
Future<List<CPlayerData>> fGetMatchMember(
    String teamName, String matchID, int matchNo, bool isStarting) async {
  // String matchNoIdx = "match" + matchNo.toString();
  // int memberCond = -1;
  List<CPlayerData> lMemberData = [];

  // 試合情報のDBから登録メンバーのIDを取得
  await FirebaseFirestore.instance
      .collection('Data2022')
      .doc(teamName)
      .collection('Match')
      .doc(matchID)
      .collection('Member').get()
  // 取得したIDから選手情報を取得
      .then((QuerySnapshot querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          if(doc["starting"].toString() == isStarting.toString()){
            await fGetMemberInfoForMemberID(teamName, doc.id).then((result) {
              lMemberData.add(result);
            } );
          }
        }
      });
  return lMemberData;
}

/*
Name : fGetMemberInfoForMemberID()
Arg  : void
Func : 選手のIDから選手名等の情報を取得
* */
Future<CPlayerData> fGetMemberInfoForMemberID(String teamName, String memberID) async {
  final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
      .collection('Data2022')
      .doc(teamName)
      .collection('Member')
      .doc(memberID).get();
  String name = docSnapshot.get("name");
  // String pos  = docSnapshot.get("position");
  int    num  = docSnapshot.get("number");
  CPlayerData returnData = CPlayerData(memberID, name, num);

  return returnData;
}

/*
Name : fSubmit()
Arg  : void
Func : 採点結果をfirebaseに格納
* */
void fSubmit(String teamName, String matchID) async {
  String userID = "tID"; // FOR DEBUG

  // 既に採点情報が格納されているか確認して、あれば新規追加ではなく更新
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Data2022')
      .doc('Scores')
      .collection(teamName)
      .where('userID', isEqualTo: userID)
      .where('matchID', isEqualTo: matchID)
      .get();

  // まだ一度も送信していない(snapshotのサイズが0)場合、新規追加
  if (snapshot.size == 0) {
    for (CPlayerData member in lStartingList!) {
      int index = 0;
      // スタメンの採点情報
      await FirebaseFirestore.instance
          .collection('Data2022')
          .doc('Scores')
          .collection(teamName)
          .doc() // ここは空欄だと自動でIDが付く
          .set({
        'MemberID': member.mid,
        'MatchID': matchID,
        'userID': userID, // TODO:後で直す。UserIDをfirebase authからDB格納できるようになってから
        'score': lSelectedPointList![index]
      }); // データ
      index++;
    }
    // サブの採点情報
    for (CPlayerData member in lSubList!) {
      int index = 11;
      await FirebaseFirestore.instance
          .collection('Data2022')
          .doc('Scores')
          .collection(teamName)
          .doc() // ここは空欄だと自動でIDが付く
          .set({
        'MemberID': member.mid,
        'MatchID': matchID,
        'userID': userID, // TODO:後で直す。UserIDをfirebase authからDB格納できるようになってから
        'score': lSelectedPointList![index]
      }); // データ

      index++;
    }
  }

  // 既に送信済なら情報をさいしんに更新する
  else{} // TODO : 今日やる
}

