import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:judge/widget/inputScore_CreateScoreImage.dart';
import 'package:url_launcher/url_launcher.dart';



class Widget_HorizontalBorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[200],
    );
  }
}

class Widget_TwitterShare extends StatelessWidget {
  final String text;
  final String url;
  final List<String> hashtags;
  final String via;
  final String related;

  const Widget_TwitterShare(
      {Key? key,
        required this.text,
        this.url = "",
        this.hashtags = const [],
        this.via = "",
        this.related = ""})
      : super(key: key);

  void _tweet(Map<String, dynamic> tweetQuery) async {

    final Uri tweetScheme =
    Uri(scheme: "twitter", host: "post", queryParameters: tweetQuery);

    final Uri tweetIntentUrl =
    Uri.https("twitter.com", "/intent/tweet", tweetQuery);

    await canLaunch(tweetScheme.toString())
        ? await launch(tweetScheme.toString())
        : await launch(tweetIntentUrl.toString());
  }

  @override
  Widget build(BuildContext context) {
    // 画像ツイートはTwitter APIが対応していないっぽいので保留
    // https://pub.dev/documentation/twitter_api_v2/latest/twitter_api_v2/TweetsService/createTweet.html
    // final globalkey = GlobalObjectKey<Widget_CreateScoreImage>(context);
    return CupertinoDialogAction(
      child: const Text("Twitterで共有"),
      onPressed: () async {
        //  var image = await globalkey.currentState?.fConvertWidgetToImage(); // 画像を生成
        final Map<String, dynamic> tweetQuery = {
          "text": text,
          "url": url,
          "hashtags": hashtags.join(","),
          "via": via,
          "related": related
        };

        _tweet(tweetQuery);
      },
    );
  }
}