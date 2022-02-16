import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/calling/calling_screen.dart';
import 'package:friend_mobile/ui/calling/agora_demo.dart';
import 'package:friend_mobile/ui/messages/widgets/message_tile.dart';
import 'package:friend_mobile/ui/user_profile/other_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../calling/jitsi.dart';

class ActualChat extends StatefulWidget {
  String channelName = "";
  ActualChat({Key? key, required this.channelName}) : super(key: key);

  @override
  _ActualChat createState() => _ActualChat();
}

class _ActualChat extends State<ActualChat> {
  String _messages = "";
  String uid1 = "";
  String uid2 = "";
  String myName = "";
  String otherName = "";
  String avatar1 = "";
  String avatar2 = "";
  final myController = new TextEditingController();
  @override
  void retrieveavatarandname() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid1)
        .get()
        .then((doc) {
      setState(() {
        avatar1 = doc['photo'];
      });
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid2)
        .get()
        .then((doc) {
      setState(() {
        avatar2 = doc['photo'];
      });
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid2)
        .get()
        .then((doc) {
      setState(() {
        otherName = doc['name'] + ' ' + doc['surname'];
      });
    });
  }

  void initState() {
    super.initState();
    setState(() {
      uid1 = FirebaseAuth.instance.currentUser!.uid;
      uid2 = widget.channelName
          .replaceAll(FirebaseAuth.instance.currentUser!.uid, "")
          .replaceAll("-", "");

      FirebaseFirestore.instance
          .collection('Users')
          .doc(uid1)
          .get()
          .then((doc) {
        myName = doc['name'] + " " + doc['surname'];
      });
    });
    retrieveavatarandname();
  }

  void onMessageSubmitted(message) {
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
        .doc(widget.channelName)
        .collection(widget.channelName)
        .doc(time + " " + widget.channelName)
        .set({
      'timestamp': Timestamp.now(),
      'sender': myName,
      "content": message,
      'uid': FirebaseAuth.instance.currentUser!.uid
    });
    myController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset("assets/icons/call.svg"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewExample(
                          channel: widget.channelName, myName: myName)),
                );
                //Navigator.pushNamed(context, CallingScreen.route);
              },
              splashRadius: 20,
              splashColor: Colors.white38,
            ),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () {},
              splashRadius: 20,
              splashColor: Colors.white38,
            ),
          ],
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, OtherProfileScreen.route);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(avatar2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                otherName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Chat")
                        .doc(widget.channelName)
                        .collection(widget.channelName)
                        .orderBy('timestamp', descending: false)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        var listMessage = snapshot.data!.docs;
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              if (listMessage[index]['uid'] ==
                                  FirebaseAuth.instance.currentUser!.uid) {
                                return MessageBubbleMe(
                                  from: listMessage[index]["sender"],
                                  textContent: listMessage[index]["content"],
                                  time: listMessage[index]["timestamp"]
                                      .toDate()
                                      .toString(),
                                  avatar: avatar1,
                                );
                              } else {
                                return MessageBubbleOther(
                                  from: listMessage[index]["sender"],
                                  textContent: listMessage[index]["content"],
                                  time: listMessage[index]["timestamp"]
                                      .toDate()
                                      .toString(),
                                  avatar: avatar2,
                                );
                              }
                            });
                      }
                    })),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: onMessageSubmitted,
                        controller: myController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Write message here ...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 0),
                    MaterialButton(
                      onPressed: () {
                        onMessageSubmitted(myController.text);
                      },
                      shape: CircleBorder(),
                      // borderRadius: BorderRadius.circular(90),
                      color: AppTheme.primaryColor,
                      child: SizedBox(
                        width: 47,
                        height: 47,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset("assets/icons/send_icom.svg"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
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
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.avatar),
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
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.avatar),
                  ),
                ),
              ),
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
