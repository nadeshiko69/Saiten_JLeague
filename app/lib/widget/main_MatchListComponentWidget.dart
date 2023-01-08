import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:judge/confirmScore/Page_confirmScore.dart';
import 'package:judge/imageFilePath.dart';
import 'package:judge/mainData.dart';
import 'package:judge/widget/_generalWidget.dart';

class Widget_MatchInfo extends StatelessWidget {
  final String imagePath;
  final int matchNo;
  final String matchID;
  final String teamName;
  final String opponent;
  final DateTime matchDay;

  const Widget_MatchInfo({
    Key? key,
    required this.imagePath,
    required this.matchNo,
    required this.matchID,
    required this.teamName,
    required this.opponent,
    required this.matchDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return ListTile(
      leading: Image.asset(imagePath),
      title: Text(
        opponent,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      trailing: Column(
        children: [
          Text("Match $matchNo",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
          Text(DateFormat('yyyy/M/d').format(matchDay),
              style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.left,
          ),
        ],
      ),
      onTap: () {
        // ページ遷移
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Page_confirmScore(
                    deviceHeight,
                    deviceWidth,
                    matchNo,
                    matchID,
                    teamName,
                    opponent,
                    matchDay)));
      },
    );
  }
}

class Widget_MatchListComponent extends StatelessWidget {
  const Widget_MatchListComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String teamName = 'Nagoya';
    return ListView.builder(
      itemCount: lAllMatch.length,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Widget_MatchInfo(
                imagePath: lTeamLogoPath[
                    Function_GetTeamLogoPathIndex(lAllMatch[index].opponent)],
                matchNo: lAllMatch[index].matchNo,
                matchID: lAllMatch[index].matchID,
                teamName: teamName,
                opponent: lAllMatch[index].opponent,
                matchDay: lAllMatch[index].day,
              ),
              Widget_HorizontalBorder(),
            ],
          ),
        );
      },
    );
  }
}
