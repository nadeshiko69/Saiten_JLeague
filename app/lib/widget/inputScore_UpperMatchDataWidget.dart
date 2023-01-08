import 'dart:math';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/mainFactory.dart';

const kSingaporeLogoUrl = 'https://user-images.githubusercontent.com/7200238/82220821-1ebc8880-995a-11ea-9d77-07edda64f05c.png';
const kQantasLogoUrl = 'https://user-images.githubusercontent.com/7200238/82220824-1fedb580-995a-11ea-8124-f59daff4ebda.png';
const kEmiratesLogoUrl = 'https://user-images.githubusercontent.com/7200238/82220816-1c5a2e80-995a-11ea-921d-38b3f991d8d2.png';
const kHainanLogoUrl = 'https://user-images.githubusercontent.com/7200238/82223309-73adce00-995d-11ea-98c0-2dba4e094aca.png';


class _TeamName extends StatelessWidget {
  final String? shortName;
  final String? fullName;

  const _TeamName({
    Key? key,
    required this.shortName,
    required this.fullName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          shortName!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        Text(
          fullName!,
          style: TextStyle(
            color: kColorFlightText.withOpacity(0.5),
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
          color: kColorFlightIcon,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(52 / 2),
      ),
      child: Transform.rotate(
        angle: pi / 4,
        child: const Icon(
          Icons.add,
          color: kColorFlightIcon,
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
          color: kColorPrimary,
          elevation: 24,
          shadowColor: kColorPrimary,
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
                    _TeamName(shortName: homeTeamName, fullName: fConverseTeamName(homeTeamName)),
                    _VersusIcon(),
                    _TeamName(shortName: fConverseTeamName_ToEngName(awayTeamName), fullName: awayTeamName),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    day.toString(),
                    style: TextStyle(color: kColorFlightText.withOpacity(0.5)),
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