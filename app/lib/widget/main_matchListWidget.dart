import 'package:flutter/material.dart';
import 'package:judge/matchDataView/matchDataView.dart';

import '../imageFilePath.dart';
import '../mainData.dart';

class Widget_HorizontalBorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[200],
    );
  }
}

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
    return ListTile(
      leading: Image.asset(imagePath),
      title: Text(
        teamName,
        style: const TextStyle(color: Colors.amber),
      ),
      trailing: Text(
        matchID,
        style: const TextStyle(color: Colors.amber),
      ),
    );
  }
}

class Widget_MatchListComponent extends StatelessWidget {
  const Widget_MatchListComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _teamName = 'Nagoya';

    return ListView.builder(
      itemCount: lAllMatch.length,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Widget_MatchInfo(
                imagePath: lTeamLogoPath[NAGOYA],
                matchNo: lAllMatch[index].matchNo,
                matchID: lAllMatch[index].matchID,
                teamName: _teamName,
                opponent: lAllMatch[index].opponent,
                matchDay: DateTime.parse(lAllMatch[index].day),
              ),
              Widget_HorizontalBorder(),
            ],
          ),
        );
      },
      // children: [
      //   _AppColumn(
      //     icon: Icon(Icons.sms, color: Colors.indigo),
      //     name: 'SMSApp',
      //     percentage: '75%',
      //   ),
      //   _HorizontalBorder(),
      // ],
    );
  }
}
