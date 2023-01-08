import 'package:flutter/material.dart';
import 'package:judge/inputScore/Factory_inputScore.dart';
import 'package:judge/mainData.dart';
import 'package:judge/widget/inputScore_BodyDispWidget.dart';
import 'package:judge/widget/inputScore_SubmitOperationWidget.dart';

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

    // 表示する Widget の一覧
    List<Widget> _pageList = [
      Widget_inputScoreBody(
          widget.deviceHeight,
          widget.deviceWidth,
          widget.teamName,
          widget.matchID,
          widget.matchNo,
          true,
          widget.matchDay),
      Widget_inputScoreBody(
          widget.deviceHeight,
          widget.deviceWidth,
          widget.teamName,
          widget.matchID,
          widget.matchNo,
          false,
          widget.matchDay),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Match ${widget.matchNo}",
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: kColorWidget,
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
                            if (myData.isAlreadyLogin) {
                              return Widget_CompleteSubmit();
                            } else {
                              return Widget_GoLoginPage();
                            }
                          },
                        );
                      }),
                    },
            icon: const Icon(Icons.arrow_circle_right),
          )
        ],
        elevation: 0,
      ),
      body: Container(
        child: _pageList[_selectedIndex],
      ),
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
