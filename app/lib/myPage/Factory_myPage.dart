import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judge/inputScore/Factory_inputScore.dart';
import 'package:judge/mainData.dart';

// Name : fGetMyInputScore()
// Arg  : teamName, matchNo : 対象チーム、節
//      : isStarting : スタメン or ベンチ / trueならスタメン, falseならベンチ
// Func : ユーザが過去に提出した採点情報を取得
// * */
Future<List<String>> fGetMyInputScore(String teamName) async {
  List<String> lAlreadyInputedMatch = [];

  // 採点情報DBからユーザが採点を提出した試合のMatchIDを取得
  await FirebaseFirestore.instance
      .collection('Data2022')
      .doc('Scores')
      .collection(teamName)
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      if (doc["userID"] == myData.userID &&
          !lAlreadyInputedMatch.contains(doc["MatchID"])) {
        lAlreadyInputedMatch.add(doc["MatchID"]);
      }
    }
  });
  print(lAlreadyInputedMatch);
  return lAlreadyInputedMatch;
}
