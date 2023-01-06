import 'package:flutter/material.dart';
import 'package:judge/imageFilePath.dart';
import 'package:judge/mainData.dart';
import 'package:judge/mainFactory.dart';
import 'package:judge/myPage/Factory_myPage.dart';
import 'package:judge/myPage/login.dart';

// Auth機能 https://www.flutter-study.dev/firebase/authentication
String teamName = "Nagoya";

// 登録画面
class CAuthPageView extends StatelessWidget {
  const CAuthPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Page"),
      ),
      body: const MyAuthPage(),
    );
  }
}

// マイページ
class CMyPageView extends StatelessWidget {
  const CMyPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: fGetMyInputedMatchData(teamName),
        builder:
            (BuildContext context, AsyncSnapshot<List<CMatchData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 通信中
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.error != null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<CMatchData>? lAlreadyInputedMatch = snapshot.data; // 描画用

          // まだメンバー登録していない時にアクセスされた場合のWarningを表示
          if (lAlreadyInputedMatch!.isEmpty) {
            return Center(
              child: Column(
                children: const [
                  Text("採点済の試合がありません。。。"),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "My Page",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white54,
              iconTheme: IconThemeData(color: Colors.black),
              // TODO : ログアウト機能要らなそうなので一旦コメントアウト
              // actions: [
              //   IconButton(
              //       onPressed: () => {},
              //       icon: const Icon(
              //         Icons.logout,
              //         color: Colors.black,
              //       ))
              // ],
            ),
            body: Column(
              children: [
                const Text(
                  "採点提出済",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: _deviceHeight * 0.7,
                  width: _deviceWidth * 0.95,
                  child: ListView.builder(
                      itemCount: lAlreadyInputedMatch.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Image.asset(lTeamLogoPath[
                                Function_GetTeamLogoPathIndex(teamName)]),
                            title: Text(
                                "VS ${lAlreadyInputedMatch[index].opponent}"),
                            subtitle: Text(lAlreadyInputedMatch[index].day),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: Icon(Icons.align_horizontal_right_rounded),
                              onPressed: () {},
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
}
