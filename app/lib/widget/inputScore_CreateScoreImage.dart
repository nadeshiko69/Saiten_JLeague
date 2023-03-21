
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'inputScore_BodyDispWidget.dart';


class Widget_CreateScoreImage extends State<Widget_inputScoreBody> {

  // グローバルキー
  final GlobalKey _globalKey = GlobalKey();
  // イメージ
  late Image _image;

  @override
  Widget build(BuildContext context) {

    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Score',
          ),
        ),
        body: Container(
          color: Colors.yellow,
          height: 200.0,
          child: Center(
            child: Row(

            ),
          ),
        ),
      ),
    );
  }

  /*
   * _globalKeyが設定されたWidgetから画像を生成し返す
   */
  Future<Image?> fConvertWidgetToImage() async {
    try {
      final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      ui.Image? image = await boundary?.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      //App directoryファイルに保存
      final directory = await getApplicationDocumentsDirectory();

      return Image.memory(pngBytes!);

    } catch (e) {
      print(e);
    }

    return null;
  }
}
