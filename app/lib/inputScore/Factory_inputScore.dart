/*
Name : fSubmit()
Arg  : void
Func : 採点結果をfirebaseに格納
* */
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class CPlayerData {
  CPlayerData(this.mid, this.name, this.number);
  String mid;
  String name;
  int    number;
}

// Submitで送信する用のリストたち
List<CPlayerData>? lStartingList = [];
List<CPlayerData>? lSubList = [];
List<double>? lSelectedPointList = [];

// Today'sMatch か NextMatchのテキストスタイル
var tsSubmitIcon = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w300,
  fontFamily: 'Roboto',
  letterSpacing: 1.0,
  fontSize: 20.0,
);

void fSubmit(String teamName, String matchID) async {
  String? userID = FirebaseAuth.instance.currentUser?.uid; // FOR DEBUG

  // 既に採点情報が格納されているか確認して、あれば新規追加ではなく更新
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Data2022')
      .doc('Scores')
      .collection(teamName)
      .where('userID', isEqualTo: userID)
      .where('MatchID', isEqualTo: matchID)
      .get();

  // まだ一度も送信していない(snapshotのサイズが0)場合、新規追加
  if (snapshot.size == 0) {
    int index = 0;
    for (CPlayerData member in lStartingList!) {
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
    index = 11;
    for (CPlayerData member in lSubList!) {
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
  // TODO: 実装汚すぎるので後でいい感じにまとめる
  else {
    print("unko");
    int index = 0;
    for (CPlayerData member in lStartingList!) {
      await FirebaseFirestore.instance
          .collection('Data2022')
          .doc('Scores')
          .collection(teamName)
          .where('userID', isEqualTo: userID)
          .where('MatchID', isEqualTo: matchID)
          .where('MemberID', isEqualTo: member.mid)
          .get()
          .then((QuerySnapshot snapshot) => {
                snapshot.docs.forEach((f) {
                  // TODO：where.getで現状forEachでループ（1回）を回すしかない。要検討
                  FirebaseFirestore.instance
                      .collection('Data2022')
                      .doc('Scores')
                      .collection(teamName)
                      .doc(f.reference.id)
                      .set({
                    'MemberID': member.mid,
                    'MatchID': matchID,
                    'userID': userID, // TODO:後で直す。UserIDをfirebase authからDB格納できるようになってから
                    'score': lSelectedPointList![index]
                  });
                })
              });

      index++;
    }
  }
}





// Name : fGetMatchMember()
// Arg  : teamName, matchNo : 対象チーム、節
//      : isStarting : スタメン or ベンチ / trueならスタメン, falseならベンチ
// Func : 該当する試合の登録メンバーを取得
// * */
Future<List<CPlayerData>> fGetMatchMember(
    String teamName, String matchID, int matchNo, bool isStarting) async {
  List<CPlayerData> lMemberData = [];

  // 試合情報のDBから登録メンバーのIDを取得
  await FirebaseFirestore.instance
      .collection('Data2022')
      .doc(teamName)
      .collection('Match')
      .doc(matchID)
      .collection('Member')
      .get()
      // 取得したIDから選手情報を取得
      .then((QuerySnapshot querySnapshot) async {
    for (var doc in querySnapshot.docs) {
      if (doc["starting"].toString() == isStarting.toString()) {
        await fGetMemberInfoForMemberID(teamName, doc.id).then((result) {
          lMemberData.add(result);
        });
      }
    }
  }
  );
  return lMemberData;
}



/*
Name : fGetMemberInfoForMemberID()
Arg  : void
Func : 選手のIDから選手名等の情報を取得
* */
Future<CPlayerData> fGetMemberInfoForMemberID(
    String teamName, String memberID) async {
  final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
      .collection('Data2022')
      .doc(teamName)
      .collection('Member')
      .doc(memberID)
      .get();
  String name = docSnapshot.get("name");
  // String pos  = docSnapshot.get("position");
  int num = docSnapshot.get("number");
  CPlayerData returnData = CPlayerData(memberID, name, num);

  return returnData;
}