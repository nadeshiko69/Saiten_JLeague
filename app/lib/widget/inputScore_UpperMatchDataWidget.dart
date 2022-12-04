import 'dart:math';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';

const kSingaporeLogoUrl = 'https://user-images.githubusercontent.com/7200238/82220821-1ebc8880-995a-11ea-9d77-07edda64f05c.png';
const kQantasLogoUrl = 'https://user-images.githubusercontent.com/7200238/82220824-1fedb580-995a-11ea-8124-f59daff4ebda.png';
const kEmiratesLogoUrl = 'https://user-images.githubusercontent.com/7200238/82220816-1c5a2e80-995a-11ea-921d-38b3f991d8d2.png';
const kHainanLogoUrl = 'https://user-images.githubusercontent.com/7200238/82223309-73adce00-995d-11ea-98c0-2dba4e094aca.png';


class _AirportName extends StatelessWidget {
  final String shortName;
  final String fullName;

  const _AirportName({
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
          shortName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        Text(
          fullName,
          style: TextStyle(
            color: kColorFlightText.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

class _FlightIcon extends StatelessWidget {
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
        angle: pi / 2,
        child: const Icon(
          Icons.flight,
          color: kColorFlightIcon,
          size: 28,
        ),
      ),
    );
  }
}

class FlightInfo extends StatelessWidget {
  const FlightInfo({Key? key}) : super(key: key);

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
                    const _AirportName(shortName: 'DHK', fullName: 'Dhaka'),
                    _FlightIcon(),
                    const _AirportName(shortName: 'LDN', fullName: 'London'),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Monday, 18 May, 2020',
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