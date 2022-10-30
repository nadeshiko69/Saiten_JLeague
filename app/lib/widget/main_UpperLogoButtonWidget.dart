import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/widget/inputScore_BodyDispWidget.dart';
import '../imageFilePath.dart';
import '../inputScore/Page_inputScore.dart';

class Widget_UpperLogoButton extends StatelessWidget {
  final String teamName;
  final String routingFor; // ダサいのでいずれ修正する
  Widget_UpperLogoButton({Key? key, required this.teamName, required this.routingFor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: (){
        // ページ遷移
          switch(routingFor) {
            case "inputScore":{
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  Page_inputScore(
                      _deviceHeight,
                      _deviceWidth,
                      lNextMatch[0].matchNo,
                      lNextMatch[0].matchID,
                      teamName,
                      lNextMatch[0].opponent,
                      DateTime.parse(lNextMatch[0].day))
              ));
              break;
            }
            case "favTeamInfo":{break;}
            default:{break;}
          }
        },
      child: Container(
        height: _deviceHeight * 0.15,
        width: _deviceWidth * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(lTeamLogoPath[Function_GetTeamLogoPathIndex(teamName)]),
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
    );
  }
}


