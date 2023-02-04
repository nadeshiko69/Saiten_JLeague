import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judge/mainData.dart';
import 'package:judge/myPage/Page_myPage.dart';

// Name : fGetMyTeamMember()
// Arg  : teamName : 対象チーム
// Func : MyTeamの選手情報を取得
// * */
Future<List<CPersonalData>> fGetMyTeamMember() async {
  List<CPersonalData> lPersonalData = []..length = 0;

  await FirebaseFirestore.instance
      .collection(Data20XX)
      .doc(teamName)
      .collection('Member')
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      if(doc["number"] != 0) {
        CPersonalData personalData =
        CPersonalData(doc["name"], doc["number"], doc["position"], -1);
        lPersonalData.add(personalData);
      }
    }
  });
  lPersonalData.sort((a, b) => a.number.compareTo(b.number));
  return lPersonalData;
}
