/// matchDataViewFactory.dart
/// matchDataView.dartで使用する関数定義

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:judge/mainData.dart';
import 'package:judge/matchDataView/matchDataViewData.dart';

/*
TODO データ追加の処理見つけたから貼っておく、あとでやる
              onPressed: () async {
                // ドキュメント作成
                await FirebaseFirestore.instance
                    .collection('test_collection1') // コレクションID
                    .doc() // ここは空欄だと自動でIDが付く
                    .set({
                  'name': 'sato',
                  'age': 20,
                  'sex': 'male',
                  'type': ['A', 'B']
                }); // データ
              },
* */

/*
TODO : https://ichi.pro/flutter-de-cloudfirestore-o-shiyosuru-hoho-174444485265984
  void _onPressed() {
  firestoreInstance.collection("users").add(
  {
    "name" : "john",
    "age" : 50,
    "email" : "example@example.com",
    "address" : {
      "street" : "street 24",
      "city" : "new york"
    }
  }).then((value){
    print(value.id);
  });
}
* */

/*
Name : GetMatchMember()
Arg  : None
Func : 該当する試合の登録メンバーを取得
* */
// TODO : factoryに実装してきれいにしたかったけどうまく行かなかったからとりあえずクラス内に作成済。あとでうまいことする
