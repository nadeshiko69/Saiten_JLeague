import 'package:flutter/material.dart';
import 'package:judge/inputScore/Factory_inputScore.dart';
import '../mainData.dart';

// Scaffold内のBodyを定義Footerでスタメンとベンチ切り替え
class Widget_inputScoreBody extends StatefulWidget {
  Widget_inputScoreBody(
      this.deviceHeight,
      this.deviceWidth,
      this.teamName,
      this.matchID,
      this.matchNo,
      this.isStarting,
      this.matchDay,
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
  State<Widget_inputScoreBody> createState() => _Body();
}

class _Body extends State<Widget_inputScoreBody> {
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
    return FutureBuilder (
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
                              )
                            // 採点集計結果を表示
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
