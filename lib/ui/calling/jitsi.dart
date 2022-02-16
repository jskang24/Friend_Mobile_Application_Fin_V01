import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WebViewExample extends StatefulWidget {
  String channel;
  String myName;
  WebViewExample({required this.channel, required this.myName});
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  String meetLink = "";

  void sendChannel() {
    var date = DateTime.now();
    String time = date.year.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.day.toString() +
        "-" +
        date.hour.toString() +
        "_" +
        date.minute.toString() +
        "_" +
        date.second.toString();
    FirebaseFirestore.instance
        .collection("Chat")
        .doc(widget.channel)
        .collection(widget.channel)
        .doc(time + " " + widget.channel)
        .set({
      'timestamp': Timestamp.now(),
      'sender': widget.myName,
      "content": 'https://meet.jit.si/' + meetLink,
      'uid': FirebaseAuth.instance.currentUser!.uid
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      meetLink = generateRandomString(20);
    });
    sendChannel();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://meet.jit.si/' + meetLink,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
