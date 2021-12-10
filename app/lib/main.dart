import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'みんなで採点J'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('コンサドーレ札幌'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('浦和レッズ'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('FC東京'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('横浜F・マリノス'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('清水エスパルス'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('名古屋グランパス'),
                        onPressed: (){// !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('セレッソ大阪'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('ヴィッセル神戸'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('アビスパ福岡'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('鹿島アントラーズ'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('柏レイソル'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('川崎フロンターレ'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('湘南ベルマーレ'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('ジュビロ磐田'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('ガンバ大阪'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('京都サンガFC'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('サンフレッチェ広島'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),

                    ButtonTheme(
                      minWidth: 170.0,
                      child: RaisedButton(
                        child: Text('サガン鳥栖'),
                        onPressed:  !_isEnabled ? null : () {
                          // 何かEnableの時の処理
                        },
                      ),
                    ),
                  ],
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
