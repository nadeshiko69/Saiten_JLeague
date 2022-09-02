import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/matchDataView/matchDataViewData.dart';
import 'package:judge/matchDataView/matchDataViewFactory.dart';

class CMatchDetailView extends StatefulWidget {
  CMatchDetailView(this.deviceHeight, this.deviceWidth, this.matchNo,
      this.matchID, this.teamName, this.opponent, this.matchDay,
      {Key? key})
      : super(key: key);
  double deviceHeight;
  double deviceWidth;
  int matchNo;
  String matchID;
  String teamName;
  String opponent;
  DateTime matchDay;

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
          widget.matchID, widget.matchNo, true, widget.matchDay),
      BodyDisp(widget.deviceHeight, widget.deviceWidth, widget.teamName,
          widget.matchID, widget.matchNo, false, widget.matchDay),
    ];
    String submitMainMsg = "ログインしてください";
    String submitSubMsg = "採点の提出にはログインが必要です。";
    if (myData.isAlreadyLogin) {
      submitMainMsg = "提出が完了しました";
      submitSubMsg = "結果発表をお待ちください！";
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Match " + widget.matchNo.toString(),
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white54,
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            onPressed: () => {
              setState(() {
                if (myData.isAlreadyLogin) {
                  fSubmit(widget.teamName, widget.matchID);
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
            icon: const Icon(Icons
                .arrow_circle_right), // Text("Submit", style:tsSubmitIcon),
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
      this.matchNo, this.isStarting, this.matchDay,
      {Key? key})
      : super(key: key);
  double deviceHeight;
  double deviceWidth;
  String teamName;
  String matchID;
  int matchNo;
  bool isStarting;
  DateTime matchDay;

  void fWriteStartingData() {}

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

        List<CPlayerData>? lMemberData = snapshot.data; // 描画用
        // Firebase 送信用
        if (widget.isStarting) {
          lStartingList = lMemberData;
        } else {
          lSubList = lMemberData;
        }

        // TODO : 表示させる試合の日程が過去なら、採点送信画面ではなく採点結果確認画面を表示する
        // 試合日の翌日と今を比較　→　試合から一日以上経っていたら結果出力
        if(widget.matchDay.add(const Duration(days:1)).difference(DateTime.now()).inDays < 0){

        }
        // 試合終了から1日以内なら採点入力画面
        else{

        }

        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Container(
                height: widget.deviceHeight * 0.10,
                width: widget.deviceWidth,
                color: Colors.amber, // FOR DEBUG
                child: Center(
                    child: Text(
                  'vs' + lAllMatch[widget.matchNo - 1].opponent,
                  style: tsOpponentNameTextStyle,
                )),
              ),
              Container(
                height: widget.deviceHeight * 0.67,
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
                                lSelectedPointList =
                                    _selectedPoints; // 送信用リストを更新
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
