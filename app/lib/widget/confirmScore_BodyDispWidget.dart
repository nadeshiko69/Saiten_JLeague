import 'package:flutter/material.dart';
import 'package:judge/confirmScore/Factory_confirmScore.dart';
import '../mainData.dart';
import 'confirmScore_UpperMatchDataView.dart';

// Scaffold内のBodyを定義Footerでスタメンとベンチ切り替え
class Widget_confirmScoreBody extends StatefulWidget {
  Widget_confirmScoreBody(this.deviceHeight, this.deviceWidth, this.teamName,
      this.matchID, this.matchNo, this.isStarting, this.matchDay,
      {Key? key})
      : super(key: key);
  double deviceHeight;
  double deviceWidth;
  String teamName;
  String matchID;
  int matchNo;
  bool isStarting;
  DateTime matchDay;
  @override
  State<Widget_confirmScoreBody> createState() => _Body();
}

class _Body extends State<Widget_confirmScoreBody> {
  DateTime accessTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    if(widget.matchDay.add(const Duration(days: 2))
        .isAfter(accessTime)) {
      return Center(
        child: SizedBox(
          height: deviceHeight * 0.7,
          child: Column(
            children: const [
              Text("まだ情報の登録が出来ていません..."),
              Text("採点の集計終了は試合終了の二日後です。"),
            ],
          ),
        ),
      );
    }
    return FutureBuilder(
      future: fGetMatchMemberWithScore(
          widget.teamName, widget.matchID, widget.matchNo, widget.isStarting),
      builder:
          (BuildContext context,
          AsyncSnapshot<List<CPlayerDataWithScore>> snapshot) {
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

        List<CPlayerDataWithScore>? lMemberData = snapshot.data; // 描画用
        // Firebase 送信用
        if (widget.isStarting) {
          lStartingListWithScore = lMemberData;
        } else {
          lSubListWithScore = lMemberData;
        }

        // 採点の集計結果がなければリストを表示しない
        if (lStartingListWithScore![0].score == -1) {
          return const Center(child: Text("採点の集計完了までしばらくお待ちください・・・"));
        }
        else {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                Widget_UpperMatchData(
                    widget.teamName, lAllMatch[widget.matchNo - 1].opponent,
                    lAllMatch[widget.matchNo - 1].day.toString(),
                    lAllMatch[widget.matchNo - 1].stadium),
                Container(
                  height: widget.deviceHeight * 0.5,
                  width: widget.deviceWidth,
                  color: Colors.white, // FOR DEBUG
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: lMemberData?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Card(
                          child: ListTile(
                              title: Text(lMemberData![index].name),
                              subtitle:
                              Text(lMemberData[index].number.toString()),
                              trailing: Column(
                                children: [
                                  Text("Ave : ${lMemberData[index].score.toStringAsFixed(2)}"),
                                  Text("Var : ${lMemberData[index].variance.toStringAsFixed(2)}"),
                                  Text("SD : ${lMemberData[index].sdev.toStringAsFixed(2)}"),

                                ],
                              )), // Firebaseから値を取得してList化してTextで出力
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
