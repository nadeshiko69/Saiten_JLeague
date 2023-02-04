import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judge/mainData.dart';
import 'package:judge/mainFactory.dart';

// Name : fGetMyInputedMatchID()
// Arg  : teamName : 対象チーム
// Func : ユーザが過去に採点を提出した試合のMatchIDを取得
// * */
Future<List<CMatchData>> fGetMyInputedMatchData(String teamName) async {
  List<CMatchData> lAlreadyInputedMatchData = [];
  List<String> lMatchIDTemp = []; // matchIDを記憶しておいて、lAlreadyInputedMatchDataに被りが発生しないように調整する用。うまく検索使えれば要らなそう。

  // 採点情報DBからユーザが採点を提出した試合のMatchIDを取得
  await FirebaseFirestore.instance
      .collection(Data20XX)
      .doc('Scores')
      .collection(teamName)
      .get()
      .then((QuerySnapshot querySnapshot) async {
    for (var doc in querySnapshot.docs) {
      print(doc);
      if (doc["userID"] == myData.userID) {
        DocumentSnapshot matchDataSnapshot = await FirebaseFirestore.instance
            .collection(Data20XX)
            .doc(teamName)
            .collection("Match")
            .doc(doc["MatchID"])
            .get();
        print(doc["MatchID"]);
        print(matchDataSnapshot["away"]);
        print(matchDataSnapshot["kickoff"]);
        print(matchDataSnapshot["section"]);
        print(matchDataSnapshot["stadium"]);
        CMatchData matchData = CMatchData(
            doc["MatchID"],
            matchDataSnapshot["home"] == fConverseTeamName(teamName)
                ? matchDataSnapshot["away"]
                : matchDataSnapshot["home"],
            matchDataSnapshot["kickoff"].toDate(),
            matchDataSnapshot["section"],
            matchDataSnapshot["stadium"]);
        print("a");
        if (!lMatchIDTemp.contains(doc["MatchID"])) {
          lAlreadyInputedMatchData.add(matchData);
          lMatchIDTemp.add(doc["MatchID"]);
        }
      }
    }
  });
  return lAlreadyInputedMatchData;
}
