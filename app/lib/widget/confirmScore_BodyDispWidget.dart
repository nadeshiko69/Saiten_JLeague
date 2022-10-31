import 'package:flutter/material.dart';
import 'package:judge/inputScore/Factory_inputScore.dart';
import '../mainData.dart';

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

  void fWriteStartingData() {}

  @override
  State<Widget_confirmScoreBody> createState() => _Body();
}

class _Body extends State<Widget_confirmScoreBody> {
  // 採点用リスト、0.5~10.0
  final List<DropdownMenuItem<double>> _candidatePoints = [];

  final List<double> _selectedPoints = List.generate(11 + 7, (i) => 6.0);

  @override
  void initState() {
    super.initState();
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

        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: widget.deviceHeight * 0.1,
                width: widget.deviceWidth * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey, //色
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Center(
                    child: Text(
                  'vs' + lAllMatch[widget.matchNo - 1].opponent,
                  style: tsOpponentNameTextStyle,
                )),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: widget.deviceHeight * 0.6,
                width: widget.deviceWidth,
                color: Colors.white, // FOR DEBUG
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
                            trailing: Text("a")),// Firebaseから値を取得してList化してTextで出力
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
