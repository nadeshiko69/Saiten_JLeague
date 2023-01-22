

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judge/mainData.dart';

class CPlayerDataWithScore {
  CPlayerDataWithScore(this.mid, this.name, this.number, this.score, this.variance, this.sdev);
  String mid;
  String name;
  int    number;
  double score;
  double variance;
  double sdev;
}

List<CPlayerDataWithScore>? lStartingListWithScore = [];
List<CPlayerDataWithScore>? lSubListWithScore = [];

// Name : fGetMatchMember()
// Arg  : teamName, matchNo : 対象チーム、節
//      : isStarting : スタメン or ベンチ / trueならスタメン, falseならベンチ
// Func : 該当する試合の登録メンバーを取得
// * */
Future<List<CPlayerDataWithScore>> fGetMatchMemberWithScore(
    String teamName, String matchID, int matchNo, bool isStarting) async {
  List<CPlayerDataWithScore> lMemberData = [];

  // 試合情報のDBから登録メンバーのIDを取得
  await FirebaseFirestore.instance
      .collection(Data20XX)
      .doc(teamName)
      .collection('Match')
      .doc(matchID)
      .collection('Member')
      .get()
  // 取得したIDから選手情報を取得
      .then((QuerySnapshot querySnapshot) async {
    for (var doc in querySnapshot.docs) {
      if (doc["starting"].toString() == isStarting.toString()) {
        await fGetMemberInfoForMemberID(teamName, doc.id).then((result) {
          result.score = doc["score"].toDouble();
          result.variance = doc["var"].toDouble();
          result.sdev = doc["sdev"].toDouble();
          lMemberData.add(result);
        });
      }
    }
  });
  return lMemberData;
}



/*
Name : fGetMemberInfoForMemberID()
Arg  : void
Func : 選手のIDから選手名等の情報を取得
* */
Future<CPlayerDataWithScore> fGetMemberInfoForMemberID(
    String teamName, String memberID) async {
  final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
      .collection(Data20XX)
      .doc(teamName)
      .collection('Member')
      .doc(memberID)
      .get();
  String name = docSnapshot.get("name");
  // String pos  = docSnapshot.get("position");
  int num = docSnapshot.get("number");
  double score = -1.0;
  double variance = -1.0;
  double sdev = -1.0;
  CPlayerDataWithScore returnData = CPlayerDataWithScore(
      memberID, name, num, score, variance, sdev);

  return returnData;
}