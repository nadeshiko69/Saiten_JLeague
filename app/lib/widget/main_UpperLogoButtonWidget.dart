import 'dart:io';

import 'package:flutter/material.dart';
import 'package:judge/imageFilePath.dart';
import 'package:judge/inputScore/Page_inputScore.dart';
import 'package:judge/mainData.dart';
import 'package:judge/mainFactory.dart';


class Widget_UpperLogoButton extends StatelessWidget {
  final String teamName;
  final String routingFor; // ダサいのでいずれ修正する
  Widget_UpperLogoButton({Key? key, required this.teamName, required this.routingFor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;

    int viewLogoIndex = 0;
    switch(routingFor){
      case "inputScore":{ viewLogoIndex = Function_GetTeamLogoPathIndex(nextMatchData.opponent);break;}
      case "favTeamInfo":{ viewLogoIndex = Function_GetTeamLogoPathIndex(teamName);break;}
      default:{break;}
    }

    switch(routingFor) {
      case "inputScore":{
        return Column(
          children: [
            Text(nextMatchData.nextOrToday, style: tsNextMatchTextStyle),
            InkWell(
              onTap: (){

                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    Page_inputScore(
                        _deviceHeight,
                        _deviceWidth,
                        nextMatchData.matchNo,
                        nextMatchData.matchID,
                        teamName,
                        nextMatchData.opponent,
                        DateTime.parse(nextMatchData.day))
                ));
              },
              child: Container(
                height: _deviceHeight * 0.15,
                width: _deviceWidth * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(lTeamLogoPath[viewLogoIndex]),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey, //色
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
      case "favTeamInfo":{
        return Column(
          children: [
            Text("MY TEAM", style: tsNextMatchTextStyle,),
            InkWell(
              onTap: (){},
              child: Container(
                height: _deviceHeight * 0.15,
                width: _deviceWidth * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(lTeamLogoPath[viewLogoIndex]),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey, //色
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
      default:{
        return Container();
      }
    }
  }
}


