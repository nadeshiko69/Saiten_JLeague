import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:judge/mainData.dart';
import 'package:judge/matchDataView/matchDataViewData.dart';
import 'package:judge/matchDataView/matchDataViewFactory.dart';

class CMatchDetailView extends StatefulWidget {
  CMatchDetailView(this.deviceHeight, this.deviceWidth, this.matchNo,
      this.matchID, this.teamName, this.opponent,
      {Key? key})
      : super(key: key);
  double deviceHeight;
  double deviceWidth;
  int matchNo;
  String matchID;
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
          widget.matchID, widget.matchNo, true),
      BodyDisp(widget.deviceHeight, widget.deviceWidth, widget.teamName,
          widget.matchID, widget.matchNo, false),
    ];
    String submitMainMsg = "ログインしてください";
    String submitSubMsg = "採点の提出にはログインが必要です。";
    if (myData.isAlreadyLogin) {
      submitMainMsg = "提出が完了しました";
      submitSubMsg = "結果発表をお待ちください！";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Match " + widget.matchNo.toString()),
        actions: <Widget>[
          TextButton(
              onPressed: () => {
                    setState(() {
                      if (myData.isAlreadyLogin) {
                        fSubmit();
                      } else {/* No Action */}

                      // ログインしていなかった場合警告を出す
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text(submitMainMsg),
                            content: Text(submitSubMsg),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: const Text("OK"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    }),
                  },
              child: Text("Submit", style:tsSubmitIcon),
          )
        ],
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
    );
  }
}

// Scaffold内のBodyを定義Footerでスタメンとベンチ切り替え
class BodyDisp extends StatefulWidget {
  BodyDisp(this.deviceHeight, this.deviceWidth, this.teamName, this.matchID,
      this.matchNo, this.isStarting,
      {Key? key})
      : super(key: key);
  double deviceHeight;
  double deviceWidth;
  String teamName;
  String matchID;
  int matchNo;
  bool isStarting;

  @override
  State<BodyDisp> createState() => _BodyDispState();
}

class _BodyDispState extends State<BodyDisp> {
  // 採点用リスト、0.5~10.0
  final List<DropdownMenuItem<double>> _candidatePoints = [];

  final List<double> _selectedPoints = List.generate(11 + 7, (i) => 6.0);

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
      future: fGetMatchMember(
          widget.teamName, widget.matchID, widget.matchNo, widget.isStarting),
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
                        final int _selectedPointsIndex;
                        if (widget.isStarting == true) {
                          _selectedPointsIndex = index;
                        } else {
                          _selectedPointsIndex = index + 11;
                        }
                        return InkWell(
                          child: Card(
                            child: ListTile(
                              title: Text(lMemberData![index].name),
                              subtitle:
                                  Text(lMemberData[index].number.toString()),
                              trailing: DropdownButton(
                                isExpanded: false,
                                items: _candidatePoints,
                                value: _selectedPoints[_selectedPointsIndex],
                                onChanged: (double? value) {
                                  setState(() {
                                    _selectedPoints[_selectedPointsIndex] =
                                        value!;
                                  });
                                },
                              ),
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
