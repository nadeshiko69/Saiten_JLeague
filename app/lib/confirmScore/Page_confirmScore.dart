import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/widget/confirmScore_BodyDispWidget.dart';

class Page_confirmScore extends StatefulWidget {
  Page_confirmScore(this.deviceHeight, this.deviceWidth, this.matchNo,
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
  State<Page_confirmScore> createState() => _confirmScoreState();
}

class _confirmScoreState extends State<Page_confirmScore> {
  int _selectedIndex = 0;
  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 表示する Widget の一覧
    List<Widget> pageList = [
      Widget_confirmScoreBody(
          widget.deviceHeight,
          widget.deviceWidth,
          widget.teamName,
          widget.matchID,
          widget.matchNo,
          true,
          widget.matchDay,),
      Widget_confirmScoreBody(
          widget.deviceHeight,
          widget.deviceWidth,
          widget.teamName,
          widget.matchID,
          widget.matchNo,
          false,
          widget.matchDay,),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Match ${widget.matchNo}",
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white54,
      ),
      body: pageList[_selectedIndex],
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
