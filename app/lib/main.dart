/// main.dart
/// メインページを管理

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card; // こっちのCardクラスをhideしないとデフォルトのCardが使用できない
import 'package:judge/mainData.dart';
import 'package:judge/mainFactory.dart';
import 'package:flutter/material.dart';
import 'package:judge/myPage/myPageViewer.dart';

import 'matchDataView/matchDataView.dart';

void main() async {
  // For Stripe
  await dotenv.load(fileName: '.env');
  final publishableKey = dotenv.get('STRIPE_KEY');
  Stripe.publishableKey = publishableKey;
  await Stripe.instance.applySettings();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CMyApp());
}

class CMyApp extends StatelessWidget {
  const CMyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Judge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CMainPage(
        userID: '',
        email: 'NOT LOGIN',
        isAlreadyLogin: false,
      ),
    );
  }
}

class CMainPage extends StatefulWidget {
  const CMainPage(
      {Key? key,
      required this.userID,
      required this.email,
      required this.isAlreadyLogin})
      : super(key: key);
  final String userID;
  final String email;
  final bool isAlreadyLogin;

  @override
  State<CMainPage> createState() => CMainPageState();
}

class CMainPageState extends State<CMainPage> {
  String _teamName = '';

  @override
  void initState() {
    super.initState();
    _teamName = 'Nagoya';
    fGetNextMatch(_teamName); // 表示用のListを作成
  }

  @override
  Widget build(BuildContext context) {
    // 端末の縦横サイズを取得
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final String _myPageText;
    if (myData.isAlreadyLogin) {
      _myPageText = 'MyPage';
    } else {
      _myPageText = 'Log in';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Judge'),
        actions: [
          IconButton(
              onPressed: () => {
                    setState(() {
                      fGetNextMatch(_teamName);
                    }),
                  },
              icon: const Icon(Icons.autorenew))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CMatchDetailView(
                            _deviceHeight,
                            _deviceWidth,
                            lNextMatch[0].matchNo,
                            lNextMatch[0].matchID,
                            _teamName,
                            lNextMatch[0].opponent),
                      ));
                },
                child: Container(
                  height: _deviceHeight * 0.15,
                  width: _deviceWidth,
                  color: Colors.blue, // FOR DEBUG
                  child: Column(
                    children: [
                      Text(
                        lNextMatch[0].nextOrToday.toString(),
                        style: tsNextMatchTextStyle,
                      ),
                      Text(
                        lNextMatch[0].day,
                        style: tsScheduleTextStyle,
                      ),
                      Text(
                        'vs' + lNextMatch[0].opponent,
                        style: tsOpponentNameTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: _deviceHeight * 0.7,
                width: _deviceWidth,
                color: Colors.red, // FOR DEBUG
                child: ListView.builder(
                  itemCount: lAllMatch.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        // タップしたときの処理
                        //print(lAllMatch[index].opponent);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CMatchDetailView(
                                  _deviceHeight,
                                  _deviceWidth,
                                  lAllMatch[index].matchNo,
                                  lAllMatch[index].matchID,
                                  _teamName,
                                  lAllMatch[index].opponent),
                            ));
                      },
                      child: Card(
                        child: ListTile(
                          title: Text("MATCH " +
                              lAllMatch[index].matchNo.toString() +
                              "  " +
                              lAllMatch[index].opponent),
                          subtitle: Text(lAllMatch[index].day + " "),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(myData.email),
            ),
            ListTile(
              title: const Text('名古屋グランパス'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_myPageText),
              onTap: () {
                if (myData.isAlreadyLogin) {
                  // 既にログインしていたらマイページ
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CMyPageView()));
                } else {
                  // まだならログイン画面
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CAuthPageView()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
