import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {

  final String postUrl;
  RecipeView({required this.postUrl});


  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {

  late String finalUrl;
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    if (widget.postUrl.contains("http://")){
      finalUrl = widget.postUrl.replaceAll("http://", "https://");
    }else{
      finalUrl = widget.postUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: Platform.isIOS? 80: 40, right: 24, left: 24, bottom: 10),
                color: Colors.black87,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Sundew", style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    ),
                    ),
                    Text("Recipes", style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),)
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 100,
                width: MediaQuery.of(context).size.width,
                child: WebView(
                  initialUrl: finalUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController){
                    setState(() {
                      _controller.complete(webViewController);
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}