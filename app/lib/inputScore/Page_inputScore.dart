import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/matchDataView/matchDataViewData.dart';
import 'package:judge/matchDataView/matchDataViewFactory.dart';

import '../widget/inputScore_BodyDispWidget.dart';

class Page_inputScore extends StatefulWidget {
  Page_inputScore(this.deviceHeight, this.deviceWidth, this.matchNo,
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
  State<Page_inputScore> createState() => _inputScoreState();
}

class _inputScoreState extends State<Page_inputScore> {
  int _selectedIndex = 0;
  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 試合日の翌日と今を比較　→　試合から一日以上経っていたら結果出力
    bool dispInput = (widget.matchDay
            .add(const Duration(days: 1))
            .difference(DateTime.now())
            .inDays) >
        0;

    // 表示する Widget の一覧
    List<Widget> _pageList = [
      Widget_inputScoreBody(
          widget.deviceHeight,
          widget.deviceWidth,
          widget.teamName,
          widget.matchID,
          widget.matchNo,
          true,
          widget.matchDay,
          dispInput),
      Widget_inputScoreBody(
          widget.deviceHeight,
          widget.deviceWidth,
          widget.teamName,
          widget.matchID,
          widget.matchNo,
          false,
          widget.matchDay,
          dispInput),
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
            onPressed: !dispInput
                ? null
                : () => {
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
                .arrow_circle_right),
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
