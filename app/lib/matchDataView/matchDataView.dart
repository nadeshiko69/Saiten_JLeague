import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/matchDataView/matchDataViewData.dart';
import 'package:judge/matchDataView/matchDataViewFactory.dart';

class cMatchDetailView extends StatefulWidget {
  cMatchDetailView(this.deviceHeight, this.deviceWidth, this.matchNo,
      this.teamName, this.opponent);
  double deviceHeight;
  double deviceWidth;
  int matchNo;
  String teamName;
  String opponent;

  @override
  State<cMatchDetailView> createState() => _cMatchDetailViewState();
}

class _cMatchDetailViewState extends State<cMatchDetailView> {
  int _selectedIndex = 0;
  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 表示する Widget の一覧
    List<Widget> _pageList = [
      BodyDisp(widget.deviceHeight, widget.deviceWidth, widget.teamName, widget.matchNo, true),
      BodyDisp(widget.deviceHeight, widget.deviceWidth, widget.teamName, widget.matchNo, false),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Match " + widget.matchNo.toString()),
      ),
      body: _pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        onTap: _onTapItem,
      ),
      // TODO : FloatingActionButtonでSubmit実装する
    );
  }
}

Future<List<cPlayerData>> GetMatchMember(String teamName, int matchNo, bool isStarting) async {
  String matchNoIdx = "match" + matchNo.toString();
  int memberCond = -1;
  List<cPlayerData> lMemberData;

  // 初期化
  lStartingMemberData.clear();
  lSubMemberData.clear();
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
        return cPlayerData(name, number);
      }).toList();

  return lMemberData;
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
  BodyDisp(this.deviceHeight, this.deviceWidth, this.teamName, this.matchNo, this.isStarting);
  double deviceHeight;
  double deviceWidth;
  String teamName;
  int matchNo;
  bool isStarting;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetMatchMember(teamName, matchNo, isStarting),
      builder: (BuildContext context, AsyncSnapshot<List<cPlayerData>> snapshot) {
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
        List<cPlayerData>? lMemberData = snapshot.data;
        print(lMemberData?.length);
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
                    itemCount: lMemberData?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Card(
                          child: ListTile(
                            title: Text(lMemberData![index].name),
                            subtitle:
                                Text(lMemberData![index].number.toString()),
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


