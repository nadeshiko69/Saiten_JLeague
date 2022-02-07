/// main.dart
/// メインページを管理

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:judge/mainData.dart';
import 'package:judge/mainFactory.dart';
import 'package:flutter/material.dart';
import 'package:judge/myPage/myPage.dart';

import 'matchDataView/matchDataView.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const cMyApp());
}

class cMyApp extends StatelessWidget {
  const cMyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Judge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const cMainPage(title: 'Judge'),
    );
  }
}

class cMainPage extends StatefulWidget {
  const cMainPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<cMainPage> createState() => cMainPageState();
}

class cMainPageState extends State<cMainPage> {
  //final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Nagoya _Schedule').snapshots();
  String _teamName = '';
  @override

  void initState(){
    super.initState();
    _teamName = 'Nagoya';
    GetNextMatch(_teamName); // 表示用のListを作成
  }

  Widget build(BuildContext context) {
    // 端末の縦横サイズを取得
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth  = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => cMatchDetailView(_deviceHeight, _deviceWidth, lNextMatch[0].matchNo, _teamName, lNextMatch[0].opponent),));
                },
                child: Container(
                  height: _deviceHeight*0.15,
                  width: _deviceWidth,
                  color: Colors.blue, // FOR DEBUG
                  child: Column(
                    children: [
                      Text(lNextMatch[0].nextOrToday!,style: NextMatchTextStyle,),
                      Text(lNextMatch[0].day,style: ScheduleTextStyle,),
                      Text('vs' + lNextMatch[0].opponent, style: OpponentNameTextStyle,),
                    ],
                  ),
                ),
              ),
              Container(
                height: _deviceHeight*0.7,
                width: _deviceWidth,
                color: Colors.red, // FOR DEBUG
                child:ListView.builder(
                  itemCount: lAllMatch.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: () async{
                        // タップしたときの処理
                        //print(lAllMatch[index].opponent);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => cMatchDetailView(_deviceHeight, _deviceWidth, lAllMatch[index].matchNo, _teamName, lAllMatch[index].opponent),));
                      },
                      child: Card(
                          child: ListTile(
                            title : Text("MATCH " + lAllMatch[index].matchNo.toString() + "  " + lAllMatch[index].opponent),
                            subtitle : Text(lAllMatch[index].day + " "),
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('名古屋グランパス'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // ListTile(
            //   title: const Text('川崎フロンターレ'),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              title: const Text('My Page'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => cMyPageView()));
              },
            ),
          ],
        ),
      ),
    );
  }
}