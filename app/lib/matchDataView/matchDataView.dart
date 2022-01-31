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
    final _matchData = FirebaseFirestore.instance
        .collection('Data')
        .doc(teamName)
        .collection('Match')
        .where("matchNo", isEqualTo: matchNo);

    final QuerySnapshot<Map<String, dynamic>> snapshot = await _matchData.get();

    final matchData = snapshot.docs.map((DocumentSnapshot document){
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String opponent = data['opponent'];
      final String day = data['date'].toString();
      final int matchNo = data['matchNo'];
      return cMatchData(opponent, day, matchNo);
    }).toList();

    print(matchData[0].matchNo);
    print(matchData[0].day);
    print(matchData[0].opponent);
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
