/// main.dart
/// メインページを管理

//import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart'
    hide Card; // こっちのCardクラスをhideしないとデフォルトのCardが使用できない
import 'package:flutter_svg/flutter_svg.dart';
import 'package:judge/inputScore/Page_inputScore.dart';
import 'package:judge/mainData.dart';
import 'package:judge/mainFactory.dart';
import 'package:flutter/material.dart';
import 'package:judge/myPage/myPageViewer.dart';
import 'package:judge/widget/main_UpperLogoButtonWidget.dart';
import 'package:judge/widget/main_MatchListComponentWidget.dart';

void main() async {
  // For Stripe
  await dotenv.load(fileName: 'lib/.env');
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
          // primarySwatch: Colors.blue,
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
        title: const Text(
          'Judge',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white54,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () => {
                    setState(() {
                      fGetNextMatch(_teamName);
                    }),
                  },
              icon: const Icon(
                Icons.autorenew,
                color: Colors.black,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Widget_UpperLogoButton(
                    teamName: fConverseTeamName(_teamName),
                    routingFor: "favTeamInfo",
                  ),
                  Widget_UpperLogoButton(
                    teamName: lNextMatch[0].opponent,
                    routingFor: "inputScore",
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: _deviceHeight * 0.7,
              width: _deviceWidth * 0.95,
              color: Colors.white,
              child: Widget_MatchListComponent(),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white54,
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
