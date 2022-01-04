/// main.dart
/// メインページを管理

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:judge/mainData.dart';
import 'package:judge/mainFactory.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Judge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'Judge'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Nagoya _Schedule').snapshots();
  @override
  Widget build(BuildContext context) {
    // 表示用のListを作成
    GetNextMatch();

    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth  = MediaQuery.of(context).size.width; //Expandで管理しているため不要
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Container(
                height: _deviceHeight*0.15,
                width: _deviceWidth,
                color: Colors.blue, // FOR DEBUG
                child: Column(
                  children: [
                    Text(lNextMatch[4],style: NextMatchTextStyle,),
                    Text(lNextMatch[3],style: ScheduleTextStyle,),
                    Text('vs' + lNextMatch[1], style: OpponentNameTextStyle,),
                  ],
                ),
              ),
              Container(
                height: _deviceHeight*0.7,
                width: _deviceWidth,
                color: Colors.red, // FOR DEBUG
                child: StreamBuilder<QuerySnapshot>(
                  stream: _usersStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return ListTile(
                          title: Row(
                            children: [
                              Text('MATCH ' + data['matchNo'].toString() + '      '),
                              Text(data['opponent']),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(data['homeOrAway']+'  :  '),
                              Text(data['day']),
                            ],
                          ),
                        );
                      }).toList(),
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
              title: const Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}