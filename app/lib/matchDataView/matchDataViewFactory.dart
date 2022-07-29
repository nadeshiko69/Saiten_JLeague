/// matchDataViewFactory.dart
/// matchDataView.dartで使用する関数定義

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:judge/mainData.dart';
import 'package:judge/matchDataView/matchDataViewData.dart';

/*
Name : fGetMatchMember()
Arg  : teamName, matchNo : 対象チーム、節
     : isStarting : スタメン or ベンチ / trueならスタメン, falseならベンチ
Func : 該当する試合の登録メンバーを取得
* */
Future<List<CPlayerData>> fGetMatchMember(
    String teamName, String matchID, int matchNo, bool isStarting) async {
  String matchNoIdx = "match" + matchNo.toString();
  // int memberCond = -1;
  List<CPlayerData> lMemberData = [];

  // 試合情報のDBから登録メンバーのIDを取得
  final baseCollection = FirebaseFirestore.instance
      .collection('Data2022')
      .doc(teamName)
      .collection('Match')
      .doc(matchID)
      .collection('Member').get();

  await baseCollection.then(
        (QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach(
            (doc) async {
              if(doc.get("starting") == isStarting.toString()) {
                //  fGetMemberInfoForMemberID(teamName, doc.id).then((result) {
                //   lMemberData.add(result);
                //   print(result);
                //   print(lMemberData.length);
                // });
                lMemberData.add(await fGetMemberInfoForMemberID(teamName, doc.id));
                print("w");
              }
            },
          ),
        },
      );
  print("unko");
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
  String pos  = docSnapshot.get("position");
  int    num  = docSnapshot.get("number");
  CPlayerData returnData = CPlayerData(name, num);

  return returnData;
}

/*
Name : fSubmit()
Arg  : void
Func : 採点結果をfirebaseに格納
* */
void fSubmit() async {
  // ドキュメント作成
  await FirebaseFirestore.instance
      .collection('Data2022')
      .doc('Scores')
      .collection('Nagoya')
      .doc(myData.email) // ここは空欄だと自動でIDが付く
      .set({
    'name': 'sato',
    'age': 20,
    'sex': 'male',
    'type': ['A', 'B']
  }); // データ
}

