import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:judge/services/admob.dart';
import 'package:judge/widget/confirmScore_BodyDispWidget.dart';

class Page_confirmTeamInfo extends StatefulWidget {
  Page_confirmTeamInfo(this.deviceHeight, this.deviceWidth, this.teamName,
      {Key? key})
      : super(key: key);
  double deviceHeight;
  double deviceWidth;
  String teamName;
  @override
  State<Page_confirmTeamInfo> createState() => _confirmTeamInfoState();
}

class _confirmTeamInfoState extends State<Page_confirmTeamInfo> {
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.teamName,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white54,
      ),
      body: Column(
        children: [
          SizedBox(
            height: deviceHeight * 0.8,
              child: const Text("準備中。。。")),
          AdmobBanner(
            adUnitId: AdMobService().getBannerAdUnitId(),
            adSize: AdmobBannerSize(
              width: MediaQuery.of(context).size.width.toInt(),
              height: AdMobService().getHeight(context).toInt(),
              name: 'SMART_BANNER',
            ),
          ),
        ],
      ),
    );
  }
}
