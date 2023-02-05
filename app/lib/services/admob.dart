import 'dart:io';
import 'package:flutter/material.dart';

class AdMobService {
  String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      // Androidの広告ユニットID
      return 'ca-app-pub-1142801310983686/7630075409';
    } else if (Platform.isIOS) {
      // iOSの広告ユニットID
      return 'ca-app-pub-1142801310983686/8125464077';
    }
    return "";
  }

  String getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-1142801310983686/5283811761';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-1142801310983686/8488559602';
    }
    return "";
  }

  // 表示するバナー広告の高さを計算
  double getHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final percent = (height * 0.06).toDouble();

    return percent;
  }
}