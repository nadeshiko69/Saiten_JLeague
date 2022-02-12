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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO : あとでSubmit実装
        },
      ),
    );
  }
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
        //print(lMemberData?.length);
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
              Row(
                children: [
                  Container(
                    height: deviceHeight * 0.6,
                    width: deviceWidth,
                    color: Colors.red, // FOR DEBUG
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
                ],
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


