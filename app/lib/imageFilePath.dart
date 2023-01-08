// 各チームのロゴの画像へのファイルパス

import 'package:flutter/foundation.dart';

const int NAGOYA = 0;
const int YOKOHAMAM = 1;
const int KAWASAKI = 2;
const int HIROSHIMA = 3;
const int COSAKA = 4;
const int FCTOKYO = 5;
const int KASHIMA = 6;
const int KASHIWA = 7;
const int URAWA = 8;
const int TOSU = 9;
const int KOBE = 10;
const int SAPPORO = 11;
const int SHONAN = 12;
const int KYOTO = 13;
const int FUKUOKA = 14;
const int NIGATA = 15;
const int GOSAKA = 16;
const int YOKOHAMAC = 17;

List<String> lTeamLogoPath = [
/* NAGOYA     */   "lib/_images/nagoya.png",
/* YOKAHAMAFM */   "lib/_images/yokohamafm.png",
/* KAWASAKI   */   "lib/_images/kawasaki.png",
/* HIROSHIMA  */   "lib/_images/hiroshima.png",
/* COSAKA     */   "lib/_images/cosaka.png",
/* FCTOKYO    */   "lib/_images/fctokyo.png",
/* KASHIMA    */   "lib/_images/kashima.png",
/* KASHIWA    */   "lib/_images/kashiwa.png",
/* URAWA      */   "lib/_images/urawa.png",
/* TOSU       */   "lib/_images/tosu.png",
/* KOBE       */   "lib/_images/kobe.png",
/* SAPPORO    */   "lib/_images/sapporo.png",
/* SHONAN     */   "lib/_images/shonan.png",
/* KYOTO      */   "lib/_images/kyoto.png",
/* FUKUOKA    */   "lib/_images/fukuoka.png",
/* NIGATA     */   "lib/_images/nigata.png",
/* GOSAKA     */   "lib/_images/gosaka.png",
/* YOKOHAMAFC */   "lib/_images/yokohamafc.png",
];

int Function_GetTeamLogoPathIndex(String teamNameJpn) {
  int ret = -1;
  try {
    switch (teamNameJpn) {
      case '名古屋':
      case 'Nagoya':
        ret = NAGOYA;
        break;
      case '横浜FM':
      case 'YokohamaM':
        ret = YOKOHAMAM;
        break;
      case '川崎':
      case 'Kawasaki':
        ret = KAWASAKI;
        break;
      case '広島':
      case 'Hiroshima':
        ret = HIROSHIMA;
        break;
      case 'C大阪':
      case 'COsaka':
        ret = COSAKA;
        break;
      case 'FC東京':
      case 'FCTokyo':
        ret = FCTOKYO;
        break;
      case '鹿島':
      case 'Kashima':
        ret = KASHIMA;
        break;
      case '柏':
      case 'Kashiwa':
        ret = KASHIWA;
        break;
      case '浦和':
      case 'Urawa':
        ret = URAWA;
        break;
      case '鳥栖':
      case 'Tosu':
        ret = TOSU;
        break;
      case '神戸':
      case 'Kobe':
        ret = KOBE;
        break;
      case '札幌':
      case 'Sapporo':
        ret = SAPPORO;
        break;
      case '湘南':
      case 'Shonan':
        ret = SHONAN;
        break;
      case '京都':
      case 'Kyoto':
        ret = KYOTO;
        break;
      case '福岡':
      case 'Fukuoka':
        ret = FUKUOKA;
        break;
      case '新潟':
      case 'Nigata':
        ret = NIGATA;
        break;
      case 'G大阪':
      case 'GOsaka':
        ret = GOSAKA;
        break;
      case '横浜FC':
      case 'YokohamaC':
        ret = YOKOHAMAC;
        break;
      case 'opponent':
        ret = -1;
        break;
      default:
        break;
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return ret;
}
