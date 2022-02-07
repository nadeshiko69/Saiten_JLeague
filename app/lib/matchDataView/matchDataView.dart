import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/matchDataView/matchDataViewData.dart';
import 'package:judge/matchDataView/matchDataViewFactory.dart';

class cMatchDetailView extends StatelessWidget {
  cMatchDetailView(this.deviceHeight, this.deviceWidth, this.matchNo,
      this.teamName, this.opponent);
  double deviceHeight;
  double deviceWidth;
  int matchNo;
  String teamName;
  String opponent;

  // 該当の試合情報を読み込み
  // TODO : あとでFactory.dartにきれいに実装する
  @override
  Future<int> GetMatchMember() async {
    int STARTING = 1; // スタメン
    int SUBSTITUTE = 0; // サブ
    //int NONMEMBER  = -1;// ベンチ外
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

    final QuerySnapshot<Map<String, dynamic>> startingSnapshot =
        await _startingData.get();

    lStartingMemberData =
        startingSnapshot.docs.map((DocumentSnapshot document) {
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

    final QuerySnapshot<Map<String, dynamic>> subSnapshot =
        await _subData.get();

    lSubMemberData = subSnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String name = data['name'];
      final int number = data['number'];
      return cPlayerData(name, number);
    }).toList();

    // print(lStartingMemberData.length);
    // print(lSubMemberData.length);

    return 0;
  }

  Future<void> GetMatchInfo() async {
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

    //print(lMatchData[0].matchNo);
    //print(lMatchData[0].day);
    //print(lMatchData[0].opponent);
  }

  @override
  Widget build(BuildContext context) {

    // スタメン情報を取得
    // 非同期なのでWidgetはFutureBuilderで作成する
    // https://qiita.com/ysknsn/items/76c6326c74dc9059ff20
    GetMatchMember();

    return Scaffold(
      appBar: AppBar(
        title: Text("Match " + matchNo.toString()),
      ),
      body: Container(
        child: FutureBuilder(
          future: GetMatchMember(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: deviceHeight * 0.15,
                      width: deviceWidth,
                      color: Colors.blue, // FOR DEBUG
                      child: Center(child: Text('vs' + lNextMatch[0].opponent,
                        style: OpponentNameTextStyle,)),
                    ),

                    Container(
                      height: deviceHeight * 0.7,
                      width: deviceWidth,
                      //color: Colors.red, // FOR DEBUG
                      child:
                      Container(
                        child: ListView.builder(
                          itemCount: lStartingMemberData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Card(
                                child: ListTile(
                                  title: Text(lStartingMemberData[index].name),
                                  subtitle: Text(lStartingMemberData[index].number.toString()),
                                  // TODO : Cardの中にDropDownButton実装する https://stackoverflow.com/questions/63782274/flutter-card-widget-with-dropdown
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // TODO : FloatingActionButtonでSubmit実装する
    );
  }
}
