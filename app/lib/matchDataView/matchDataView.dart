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

  // 表示する Widget の一覧
  static List<Widget> _pageList = [
    // CustomPage(pannelColor: Colors.cyan, title: 'Home'),
    // CustomPage(pannelColor: Colors.green, title: 'Settings'),
    // CustomPage(pannelColor: Colors.pink, title: 'Search')
  ];

  @override
  Widget build(BuildContext context) {
    // スタメン情報を取得
    // 非同期なのでWidgetはFutureBuilderで作成する
    // https://qiita.com/ysknsn/items/76c6326c74dc9059ff20

    return Scaffold(
      appBar: AppBar(
        title: Text("Match " + matchNo.toString()),
      ),
      body: BodyDisp(deviceHeight, deviceWidth, teamName, matchNo, lSubMemberData),
      bottomNavigationBar: FooterDisp(),
      // TODO : FloatingActionButtonでSubmit実装する
    );
  }
}

Future<int> GetMatchMember(String teamName, int matchNo) async {
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

// Scaffold内のBodyを定義Footerでスタメンとベンチ切り替え
class BodyDisp extends StatelessWidget {
  BodyDisp(this.deviceHeight, this.deviceWidth, this.teamName, this.matchNo, this.lPlayerData);
  double deviceHeight;
  double deviceWidth;
  String teamName;
  int matchNo;
  List<cPlayerData> lPlayerData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetMatchMember(teamName, matchNo),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){ // 通信中
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(snapshot.error != null){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Container(
                height: deviceHeight * 0.15,
                width: deviceWidth,
                color: Colors.blue, // FOR DEBUG
                child: Center(
                    child: Text(
                  'vs' + lAllMatch[matchNo - 1].opponent,
                  style: OpponentNameTextStyle,
                )),
              ),
              Container(
                height: deviceHeight * 0.6,
                width: deviceWidth,
                color: Colors.red, // FOR DEBUG
                child: Container(
                  child: ListView.builder(
                    itemCount: lPlayerData.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Card(
                          child: ListTile(
                            title: Text(lPlayerData[index].name),
                            subtitle:
                                Text(lPlayerData[index].number.toString()),
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
        );
      },
    );
  }
}

// Scaffold内のFooterを定義
class FooterDisp extends StatefulWidget {
  const FooterDisp();

  @override
  _Footer createState() => _Footer();
}

class _Footer extends State {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_run),
          label: 'Starting Member',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.switch_left),
          label: 'Substitute',
        ),
      ],
    );
  }
}
