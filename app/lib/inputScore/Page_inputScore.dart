import 'dart:core';
import 'dart:core';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:judge/inputScore/Factory_inputScore.dart';
import 'package:judge/mainData.dart';
import 'package:judge/services/admob.dart';
import 'package:judge/widget/inputScore_BodyDispWidget.dart';
import 'package:judge/widget/inputScore_SubmitOperationWidget.dart';
import 'package:judge/services/admob.dart';

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

  AdmobBannerSize? bannerSize;
  late AdmobInterstitial interstitialAd;
  late AdmobReward rewardAd;

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
            onPressed: (widget.matchDay
                    .add(const Duration(hours: 2))
                    .isAfter(DateTime.now())) // input可能期間じゃなければ採点ボタンを非活性にする
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
                            if (myData.isAlreadyLogin) { // ログイン済
                              if (widget.matchDay
                                  .add(const Duration(hours: 2)) // かつ提出期間内（試合後二日以内）
                                  .isAfter(DateTime.now())) {
                                return Widget_CompleteSubmit(); // firebaseに送信
                              } else {
                                return Widget_SubmitTimeOver(); // 期間外だと警告
                              }
                            } else {
                              return Widget_GoLoginPage(); // ログインページに遷移
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
      body: SizedBox(

          child: Column(
            children: [
              Expanded(child: _pageList[_selectedIndex]),
              AdmobBanner(
                adUnitId: AdMobService().getBannerAdUnitId(),
                adSize: AdmobBannerSize(
                  width: MediaQuery.of(context).size.width.toInt(),
                  height: AdMobService().getHeight(context).toInt(),
                  name: 'SMART_BANNER',
                ),
              ),
            ],
          )),
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
