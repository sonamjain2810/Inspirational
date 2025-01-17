import 'dart:async';
import 'dart:io';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'data/Messages.dart';
import 'data/Strings.dart';
import 'utils/SizeConfig.dart';

/*
how to pass data into another screen watch this video
https://www.youtube.com/watch?v=d5PpeNb-dOY
 */
class MessageDetailPage extends StatefulWidget {
  String type;
  int defaultIndex;
  MessageDetailPage(this.type, this.defaultIndex);
  @override
  _MessageDetailPageState createState() =>
      _MessageDetailPageState(type, defaultIndex);
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  String type;

  int defaultIndex;
  _MessageDetailPageState(this.type, this.defaultIndex);
  static final facebookAppEvents = FacebookAppEvents();
  var data = [];

  late BannerAd bannerAd1;
  bool isBannerAdLoaded = false;
  @override
  void initState() {
    super.initState();
    bannerAd1 = GetBannerAd();
  }

  BannerAd GetBannerAd() {
    return BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: Platform.isAndroid
            ? Strings.androidAdmobBannerId
            : Strings.iosAdmobBannerId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            isBannerAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          isBannerAdLoaded = true;
          ad.dispose();
        }),
        request: const AdRequest())
      ..load();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd1.dispose();
  }

  @override
  Widget build(BuildContext context) {
        if (type == '1') {
      // English
      data = Messages.hindiQuotesData;
    } 
    if (type == '2') {
      // English
      data = Messages.lifeQuotesData;
    }
    if (type == '3') {
      // English
      data = Messages.positiveThinkingData;
    }
    if (type == '4') {
      // English
      data = Messages.studentQuotesData;
    }
    if (type == '5') {
      // English
      data = Messages.successQuotesData;
    }
     if (type == '6') {
      // English
      data = Messages.teamWorkQuotes;
    }
    if (type == '7') {
      // English
      data = Messages.workQuotes;
    }

    
    return PageView.builder(
      controller: PageController(
          initialPage: defaultIndex, keepPage: true, viewportFraction: 1),
      itemBuilder: (context, index) {
        return Scaffold(
          appBar: AppBar(
              title: Text(
            "Message No. ${index + 1}",
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          )),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(1.93 * SizeConfig.widthMultiplier),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(1.93 * SizeConfig.widthMultiplier),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(data[index],
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 1.93 * SizeConfig.widthMultiplier),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Builder(builder: (BuildContext context) {
                                return ElevatedButton(
                                    child: const Text("Share"),
                                    onPressed: () {
                                      debugPrint("Share Button Clicked");
                                      _onShare(
                                          context,
                                          data[index] +
                                              "\n" +
                                              "Share Via:" +
                                              "\n" +
                                              Strings.shareAppText);
                                    });
                              }),
                            ],
                          ),
                        ),
                        const Divider(),
                        //banner
                        Center(
                          child: SizedBox(
                            height: bannerAd1.size.height.toDouble(),
                            width: bannerAd1.size.width.toDouble(),
                            child: AdWidget(ad: bannerAd1),
                          ),
                        ),
                        //banner
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onShare(BuildContext context, String text) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final box = context.findRenderObject() as RenderBox?;

    /*if (imagePaths.isNotEmpty) {
      final files = <XFile>[];
      for (var i = 0; i < imagePaths.length; i++) {
        files.add(XFile(imagePaths[i], name: imageNames[i]));
      }
      await Share.shareXFiles(files,
          text: text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {*/
    await Share.share(text,
        subject: "Share",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    //}
  }

  Future<void> shareText(String message) async {
    try {
      Share.share(message);
    } catch (e) {
      debugPrint('error: $e');
    }

    facebookAppEvents.logEvent(
      name: "Message Share",
      parameters: {
        'message_shared': message,
      },
    );
  }
}
