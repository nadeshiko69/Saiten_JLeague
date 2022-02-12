//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/matchDataView/matchDataViewData.dart';
import 'package:judge/matchDataView/matchDataViewFactory.dart';

class CMatchDetailView extends StatefulWidget {
  CMatchDetailView(this.deviceHeight, this.deviceWidth, this.matchNo,
      this.teamName, this.opponent, {Key? key}) : super(key: key);
  double deviceHeight;
  double deviceWidth;
  int matchNo;
  String teamName;
  String opponent;

  @override
  State<CMatchDetailView> createState() => _CMatchDetailViewState();
}

class _CMatchDetailViewState extends State<CMatchDetailView> {
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
      BodyDisp(widget.deviceHeight, widget.deviceWidth, widget.teamName,
          widget.matchNo, true),
      BodyDisp(widget.deviceHeight, widget.deviceWidth, widget.teamName,
          widget.matchNo, false),
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
class BodyDisp extends StatefulWidget {
  BodyDisp(this.deviceHeight, this.deviceWidth, this.teamName, this.matchNo,
      this.isStarting, {Key? key}) : super(key: key);
  double deviceHeight;
  double deviceWidth;
  String teamName;
  int matchNo;
  bool isStarting;

  @override
  State<BodyDisp> createState() => _BodyDispState();
}

class _BodyDispState extends State<BodyDisp> {
  // 採点用リスト、0.5~10.0
  final List<DropdownMenuItem<double>> _candidatePoints = [];

  final List<double> _selectedPoints = List.generate(11+7, (i)=> 6.0);

  @override
  void initState() {
    super.initState();
    setItems();
  }

  void setItems() {
    // candidateに0.5~10.0の値を入れる
    for (int i = 0; i < 20; i++) {
      _candidatePoints.add(DropdownMenuItem(
        child: Text(
          (i / 2 + 0.5).toString(),
          style: const TextStyle(fontSize: 10.0),
        ),
        value: (i / 2 + 0.5),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          fGetMatchMember(widget.teamName, widget.matchNo, widget.isStarting),
      builder:
          (BuildContext context, AsyncSnapshot<List<CPlayerData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 通信中
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.error != null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if(widget.isStarting == true) {}
        else {}

        List<CPlayerData>? lMemberData = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Container(
                height: widget.deviceHeight * 0.15,
                width: widget.deviceWidth,
                color: Colors.blue, // FOR DEBUG
                child: Center(
                    child: Text(
                  'vs' + lAllMatch[widget.matchNo - 1].opponent,
                  style: tsOpponentNameTextStyle,
                )),
              ),
              Row(
                children: [
                  Container(
                    height: widget.deviceHeight * 0.6,
                    width: widget.deviceWidth,
                    color: Colors.red, // FOR DEBUG
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: lMemberData?.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Card(
                            child: ListTile(
                              title: Text(lMemberData![index].name),
                              subtitle: Text(
                                  lMemberData[index].number.toString()),
                              trailing: DropdownButton(
                                isExpanded: false,
                                items: _candidatePoints,
                                value: _selectedPoints[index],
                                onChanged: (double? value) {
                                  setState(() {
                                    _selectedPoints[index] = value!;
                                  });
                                },
                                //   hint: Align(
                                //     alignment: Alignment.centerRight,
                                //     child: Text(
                                //       "Select Item Type",
                                //       style: TextStyle(color: Colors.grey),
                                //     ),
                                //   ),
                                //   style:
                                //   TextStyle(color: Colors.black, decorationColor: Colors.red),
                              ),
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
  const FooterDisp({Key? key}) : super(key: key);

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
