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
  List<CPlayerData> lMemberData;
  // // 初期化
  // if (isStarting) {
  //   memberCond = 1;
  // } else {
  //   memberCond = 0;
  // }
  // 試合情報のDBから登録メンバーのIDを取得
  final baseCollection = FirebaseFirestore.instance
      .collection('Data2022')
      .doc(teamName)
      .collection('Match')
      .doc(matchID)
      .collection('Member').get();
  List lMemList = [];
  await baseCollection.then(
        (QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach(
            (doc) {
              print("a");
              lMemList.add(fGetMemberInfoForMemberID(teamName, doc.id));
              print(lMemList.length);
            },
          ),
        },
      );
  final _memberData = FirebaseFirestore.instance
      .collection('Data2022')
      .doc(teamName)
      .collection('Match')
      .doc(matchID)
      .collection('Member')
      .where('isStarting', isEqualTo: isStarting);
  print("b");
  final QuerySnapshot<Map<String, dynamic>> memberSnapshot =
      await _memberData.get();
  print("c");
  lMemberData = memberSnapshot.docs.map((DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    // ここに入ってきていない
    final String name = data['name'];
    final int number = data['number'];
    print("d");
    return CPlayerData(name, number);
  }).toList();
  print("e");
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

