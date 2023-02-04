import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/myPage/Page_myPage.dart';
import 'package:judge/services/admob.dart';
import 'package:judge/widget/confirmScore_BodyDispWidget.dart';

import 'Factory_confirmTeamInfo.dart';

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
              child: FutureBuilder(
                  future: fGetMyTeamMember(),
                  builder:
                      (BuildContext context, AsyncSnapshot<List<CPersonalData>> snapshot) {
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
                    List<CPersonalData>? lPersonalData = snapshot.data;

                    // まだメンバー登録していない時にアクセスされた場合のWarningを表示
                    if (lPersonalData!.isEmpty) {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text(
                            teamName,
                            style: const TextStyle(
                              fontSize: 20,
                              color: kColorBlackText,
                            ),
                          ),
                          backgroundColor: kColorWidget,
                          iconTheme: const IconThemeData(color: kColorBlackText),
                        ),
                        body: const Text("チーム情報の読み込みに失敗しました。"),
                      );
                    }

                    return ListView.builder(
                          itemCount: lPersonalData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Text(lPersonalData[index].number.toString()),
                                title: Text(
                                    lPersonalData[index].name),
                                subtitle: Text(lPersonalData[index].position),
                                isThreeLine: true,
                                trailing: IconButton(
                                  icon: const Icon(
                                      Icons.align_horizontal_right_rounded),
                                  onPressed: () {},
                                ),
                              ),
                            );
                          });
                  }
                  ),
            ),
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
