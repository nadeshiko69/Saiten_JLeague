/// matchDataViewFactory.dart
/// matchDataView.dartで使用する関数定義

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:judge/matchDataView/matchDataViewData.dart';

/*
TODO データ追加の処理見つけたから貼っておく、あとでやる
              onPressed: () async {
                // ドキュメント作成
                await FirebaseFirestore.instance
                    .collection('test_collection1') // コレクションID
                    .doc() // ここは空欄だと自動でIDが付く
                    .set({
                  'name': 'sato',
                  'age': 20,
                  'sex': 'male',
                  'type': ['A', 'B']
                }); // データ
              },
* */

/*
TODO : https://ichi.pro/flutter-de-cloudfirestore-o-shiyosuru-hoho-174444485265984
  void _onPressed() {
  firestoreInstance.collection("users").add(
  {
    "name" : "john",
    "age" : 50,
    "email" : "example@example.com",
    "address" : {
      "street" : "street 24",
      "city" : "new york"
    }
  }).then((value){
    print(value.id);
  });
}
* */

/*
Name : GetMatchMember()
Arg  : teamName, matchNo : 対象チーム、節
     : isStarting : スタメン or ベンチ / trueならスタメン, falseならベンチ
Func : 該当する試合の登録メンバーを取得
* */
Future<List<CPlayerData>> fGetMatchMember(String teamName, int matchNo, bool isStarting) async {
  String matchNoIdx = "match" + matchNo.toString();
  int memberCond = -1;
  List<CPlayerData> lMemberData;

  // 初期化
  if(isStarting) {memberCond = 1;}
  else           {memberCond = 0;}

  final _memberData = FirebaseFirestore.instance
      .collection('Data')
      .doc(teamName)
      .collection('Member')
      .where(matchNoIdx, isEqualTo: memberCond);

  final QuerySnapshot<Map<String, dynamic>> memberSnapshot =
  await _memberData.get();

  lMemberData =
      memberSnapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final String name = data['name'];
        final int number = data['number'];
        return CPlayerData(name, number);
      }).toList();

  return lMemberData;
}

// 使用しないので一旦コメントアウト
/*
Future<void> GetMatchInfo(String teamName, int matchNo) async {
  final _matchData = FirebaseFirestore.instance
      .collection('Data')
      .doc(teamName)
      .collection('Match')
      .where("matchNo", isEqualTo: matchNo);

  final QuerySnapshot<Map<String, dynamic>> snapshot = await _matchData.get();

  final lMatchData = snapshot.docs.map((DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final String opponent = data['opponent'];
    final String day = data['date'].toString();
    final int matchNo = data['matchNo'];
    return cMatchData(opponent, day, matchNo);
  }).toList();
}
*/


void fSubmit() async {
  // ドキュメント作成
  // await FirebaseFirestore.instance
  //     .collection('test_collection1') // コレクションID
  //     .doc() // ここは空欄だと自動でIDが付く
  //     .set({
  //   'name': 'sato',
  //   'age': 20,
  //   'sex': 'male',
  //   'type': ['A', 'B']
  // }); // データ
}

