import 'dart:math';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/mainFactory.dart';

class _TeamName extends StatelessWidget {
  final String? jpnName;
  final String? engName;

  const _TeamName({
    Key? key,
    required this.jpnName,
    required this.engName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          jpnName!,
          style: const TextStyle(
            color: kColorBlackText,
            fontSize: 32,
          ),
        ),
        Text(
          engName!,
          style: TextStyle(
            color: kColorBlackText.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

class _VersusIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(
          color: kColorGold,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(52 / 2),
      ),
      child: Transform.rotate(
        angle: pi / 4,
        child: const Icon(
          Icons.add,
          color: kColorGold,
          size: 28,
        ),
      ),
    );
  }
}

class Widget_UpperMatchData extends StatelessWidget {
  const Widget_UpperMatchData(this.homeTeamName, this.awayTeamName,this.day,{Key? key}) : super(key: key);
  final String homeTeamName;
  final String awayTeamName;
  final String day;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: kColorWidget,
          elevation: 24,
          shadowColor: kColorWidget,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: 32,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TeamName(jpnName:fConverseTeamName(homeTeamName) , engName: homeTeamName),
                    _VersusIcon(),
                    _TeamName(jpnName: awayTeamName, engName: fConverseTeamName_ToEngName(awayTeamName)),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    outputDateFormat.format(DateTime.parse(day)).toString(),
                    style: TextStyle(color: kColorBlackText.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}