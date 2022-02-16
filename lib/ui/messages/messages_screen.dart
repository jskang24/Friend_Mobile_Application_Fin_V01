import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/calling/calling_screen.dart';
import 'package:friend_mobile/ui/messages/widgets/message_tile.dart';
import 'package:friend_mobile/ui/user_profile/other_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friend_mobile/ui/messages/actual_chat.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late PageController _pageController;
  String _messages = "";
  var channelsList = [];
  var channelNameToName = [];
  final myController = new TextEditingController();
  channelsListToName() async {
    for (var i in channelsList) {
      String result = i
          .replaceAll(FirebaseAuth.instance.currentUser!.uid, "")
          .replaceAll("-", "");
      FirebaseFirestore.instance
          .collection('Users')
          .doc(result)
          .get()
          .then((doc) {
        setState(() {
          channelNameToName.add(doc['name'] + " " + doc['surname']);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      setState(() {
        channelsList = doc["Channels"];
        //channelsList.removeAt(0);
        channelsListToName();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Messages",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              try {
                return MessageTile(
                  label: channelNameToName[index],
                  count: "2568",
                  description: 'New unreaded message is here',
                  timeStamp: '1hour ago',
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ActualChat(channelName: channelsList[index])),
                    );
                  },
                );
              } catch (e) {
                return CircularProgressIndicator();
              }
            }, childCount: channelsList.length),
          ),
        ],
      ),
    );
  }
}

class MessageBubbleMe extends StatefulWidget {
  const MessageBubbleMe({
    Key? key,
    required this.from,
    required this.textContent,
    required this.time,
    required this.avatar,
  }) : super(key: key);
  final String from, textContent, time, avatar;
  @override
  _MessageBubbleMeState createState() => _MessageBubbleMeState();
}

class _MessageBubbleMeState extends State<MessageBubbleMe> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.from,
                  style: const TextStyle(),
                ),
                Text(
                  widget.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Bubble(
                  nip: BubbleNip.rightTop,
                  padding: const BubbleEdges.all(12),
                  showNip: true,
                  color: AppTheme.primaryColor,
                  child: Text(
                    widget.textContent,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Image.asset(widget.avatar)
            ],
          ),
        ],
      ),
    );
  }
}

class MessageBubbleOther extends StatefulWidget {
  const MessageBubbleOther({
    Key? key,
    required this.from,
    required this.textContent,
    required this.time,
    required this.avatar,
  }) : super(key: key);
  final String from, textContent, time, avatar;
  @override
  State<MessageBubbleOther> createState() => _MessageBubbleOtherState();
}

class _MessageBubbleOtherState extends State<MessageBubbleOther> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.from,
                  style: const TextStyle(),
                ),
                Text(
                  widget.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(widget.avatar),
              const SizedBox(width: 6),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Bubble(
                  nip: BubbleNip.leftTop,
                  showNip: true,
                  color: Colors.transparent,
                  borderUp: true,
                  borderColor: Colors.grey.shade300,
                  padding: const BubbleEdges.all(12),
                  child: Text(
                    widget.textContent,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
