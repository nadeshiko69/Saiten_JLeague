import 'package:flutter/material.dart';
import '../imageFilePath.dart';

class Widget_UpperLogoButton extends StatelessWidget {
  final String teamName;
  const Widget_UpperLogoButton({Key? key, required this.teamName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: (){
        // ページ遷移
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
