// 各チームのロゴの画像へのファイルパス

import 'package:flutter/foundation.dart';

const int NAGOYA = 0;
const int YOKOHAMA = 1;
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
const int SHIMIZU = 15;
const int GOSAKA = 16;
const int IWATA = 17;

List<String> lTeamLogoPath = [
  "lib/image/1327_grampus_logo.jpg",
  "lib/image/1325_yokohamafmarinos_logo.jpg",
  "lib/image/1331_frontale_logo.jpg",
  "lib/image/1323_sanfrecce_logo.jpg",
  "lib/image/1358_osakafc_logo.jpg",
  "lib/image/1326_fctokyo_logo.jpg",
  "lib/image/1324_antlers_logo.jpg",
  "lib/image/1321_reysol_logo.jpg",
  "lib/image/1320_urawared_logo.jpg",
  "lib/image/1337_sagantosu_logo.jpg",
  "lib/image/1328_vissel_logo.jpg",
  "lib/image/1355_consadole_logo.jpg",
  "lib/image/1329_bellmare_logo.jpg",
  "lib/image/1345_sanga_logo.jpg",
  "lib/image/1350_avispa_logo.jpg",
  "lib/image/1330_spulse_logo.jpg",
  "lib/image/1322_gamba_logo.jpg",
  "lib/image/1339_jubilo_logo.jpg",
];

int Function_GetTeamLogoPathIndex(String teamNameJpn) {
  int ret = -1;
  try {
    switch (teamNameJpn) {
      case '名古屋': ret = NAGOYA; break;
      case '横浜FM': ret = YOKOHAMA; break;
      case '川崎': ret = KAWASAKI; break;
      case '広島': ret = HIROSHIMA; break;
      case 'C大阪': ret = COSAKA; break;
      case 'FC東京': ret = FCTOKYO; break;
      case '鹿島': ret = KASHIMA; break;
      case '柏': ret = KASHIWA; break;
      case '浦和': ret = URAWA; break;
      case '鳥栖': ret = TOSU; break;
      case '神戸': ret = KOBE; break;
      case '札幌': ret = SAPPORO; break;
      case '湘南': ret = SHONAN; break;
      case '京都': ret = KYOTO; break;
      case '福岡': ret = FUKUOKA; break;
      case '清水': ret = SHIMIZU; break;
      case 'G大阪': ret = GOSAKA; break;
      case '磐田': ret = IWATA; break;
      default:
        break;
    }
  } catch (e) {
    if (kDebugMode) { print(e); }
  }
  return ret;
}
