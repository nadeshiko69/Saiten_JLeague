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
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize? bannerSize;
  late AdmobInterstitial interstitialAd;
  late AdmobReward rewardAd;

  int _selectedIndex = 0;
  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initState() {
    super.initState();
    bannerSize = AdmobBannerSize.BANNER;

    rewardAd = AdmobReward(
      adUnitId: AdMobService().getRewardBasedVideoAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        // handleEvent(event, args, 'Reward'); //FOR DEBUG
      },
    );
    rewardAd.load();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext!,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                return true;
              },
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args!['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 端末の縦横サイズを取得
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

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
                : () async => {
                      // if (await rewardAd.isLoaded)
                      //   {
                      //    rewardAd.show(),
                      setState(() {
                        if (myData.isAlreadyLogin) {
                          fSubmit(widget.teamName, widget.matchID);
                        } else {
                          /* No Action */
                        }

                        // ログインしていなかった場合警告を出す
                        showDialog(
                          context: context,
                          builder: (context) {
                            if (myData.isAlreadyLogin) {
                              // ログイン済
                              if (DateTime.now() // かつ提出期間内（試合後二日以内）
                                  .isAfter(widget.matchDay
                                      .add(const Duration(hours: 2)))) {
                                if(lSubList!.isEmpty) {
                                  return Widget_PromptSubScore(); // サブの採点を要求
                                }
                                else {
                                  return Widget_CompleteSubmit(); // firebaseに送信
                                }
                                } else {
                                return Widget_SubmitTimeOver(); // 期間外だと警告
                              }
                            } else {
                              return Widget_GoLoginPage(); // ログインページに遷移
                            }
                          },
                        );
                      }),
                      // }
                      //             else{
                      // showSnackBar('Reward ad is still loading...'),
                      //             }
                    },
            icon: const Icon(Icons.arrow_circle_right),
          )
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
              height: deviceHeight * 0.75,
              width: deviceWidth,
              child: _pageList[_selectedIndex]),
        ],
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
