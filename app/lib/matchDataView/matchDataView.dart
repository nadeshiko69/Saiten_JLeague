import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/matchDataView/matchDataViewData.dart';
import 'package:judge/matchDataView/matchDataViewFactory.dart';

class cMatchDetailView extends StatelessWidget {
  cMatchDetailView(this.matchNo, this.teamName, this.opponent);
  int matchNo;
  String teamName;
  String opponent;

  // 該当の試合情報を読み込み
  // TODO : あとでFactory.dartにきれいに実装する
  @override
  void GetMatchMember() async {
    int STARTING   = 1; // スタメン
    int SUBSTITUTE = 0; // サブ
    int NONMEMBER  = -1;// ベンチ外
    String matchNoIdx = "match" + matchNo.toString();

    // 初期化
    lStartingMemberData.clear();
    lSubMemberData.clear();

    // スタメンを取得
    final _startingData = FirebaseFirestore.instance
        .collection('Data')
        .doc(teamName)
        .collection('Member')
        .where(matchNoIdx, isEqualTo: STARTING);

    final QuerySnapshot<Map<String, dynamic>> startingSnapshot = await _startingData.get();

    lStartingMemberData = startingSnapshot.docs.map((DocumentSnapshot document){
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String name = data['name'];
      final int number = data['number'];
      return cPlayerData(name, number);
    }).toList();

    // サブを取得
    final _subData = FirebaseFirestore.instance
        .collection('Data')
        .doc(teamName)
        .collection('Member')
        .where(matchNoIdx, isEqualTo: SUBSTITUTE);

    final QuerySnapshot<Map<String, dynamic>> subSnapshot = await _subData.get();

    lSubMemberData = subSnapshot.docs.map((DocumentSnapshot document){
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String name = data['name'];
      final int number = data['number'];
      return cPlayerData(name, number);
    }).toList();

    print(lStartingMemberData.length);
    print(lSubMemberData.length);
  }

  void GetMatchInfo() async {
    final _matchData = FirebaseFirestore.instance
        .collection('Data')
        .doc(teamName)
        .collection('Match')
        .where("matchNo", isEqualTo: matchNo);

    final QuerySnapshot<Map<String, dynamic>> snapshot = await _matchData.get();

    final lMatchData = snapshot.docs.map((DocumentSnapshot document){
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String opponent = data['opponent'];
      final String day = data['date'].toString();
      final int matchNo = data['matchNo'];
      return cMatchData(opponent, day, matchNo);
    }).toList();

    print(lMatchData[0].matchNo);
    print(lMatchData[0].day);
    print(lMatchData[0].opponent);
  }

  @override
  Widget build(BuildContext context) {
    GetMatchMember();

    return Scaffold(
      appBar: AppBar(
        title: Text(matchNo.toString()),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.red,
      ),
    );
  }
}
