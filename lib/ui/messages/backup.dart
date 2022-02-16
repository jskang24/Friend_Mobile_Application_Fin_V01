import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/calling/calling_screen.dart';
import 'package:friend_mobile/ui/messages/widgets/message_tile.dart';
import 'package:friend_mobile/ui/user_profile/other_profile_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late PageController _pageController;
  String _messages = "";
  final myController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
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
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return MessageTile(
                      label: "Adam Smith",
                      count: "2568",
                      description: 'New unreaded message is here',
                      timeStamp: '1hour ago',
                      index: index,
                      onTap: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOutCirc,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.secondaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            leading: IconButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCirc,
                );
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            actions: [
              IconButton(
                icon: SvgPicture.asset("assets/icons/call.svg"),
                onPressed: () {
                  Navigator.pushNamed(context, CallingScreen.route);
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
                  child: Image.asset("assets/images/message_avatar.png"),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Adam Smith",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 320,
                child: CustomScrollView(
                  reverse: true,
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const MessageBubbleMe(
                            from: "Samuel Jackson (You)",
                            textContent:
                                "Proin sed diam volutpat at nunc tristique sed. Eros, sit pellentesque tristique sit viverra nibh. Tellus odio eu ultrices quisque a praesent.",
                            time: "14:01",
                            avatar: "assets/images/message_avatar.png",
                          ),
                          const MessageBubbleOther(
                            from: "Adam Smith",
                            textContent:
                                "Proin sed diam volutpat at nunc tristique sed. Eros, sit pellentesque tristique sit viverra nibh. Tellus odio eu ultrices quisque a praesent.",
                            time: "14:01",
                            avatar: "assets/images/message_avatar.png",
                          ),
                          const MessageBubbleMe(
                            from: "Samuel Jackson (You)",
                            textContent:
                                "Proin sed diam volutpat at nunc tristique sed. Eros, sit pellentesque tristique sit viverra nibh. Tellus odio eu ultrices quisque a praesent.",
                            time: "14:01",
                            avatar: "assets/images/message_avatar.png",
                          ),
                          const MessageBubbleOther(
                            from: "Adam Smith",
                            textContent:
                                "Proin sed diam volutpat at nunc tristique sed. Eros, sit pellentesque tristique sit viverra nibh. Tellus odio eu ultrices quisque a praesent.",
                            time: "14:01",
                            avatar: "assets/images/message_avatar.png",
                          ),
                          const MessageBubbleMe(
                            from: "Samuel Jackson (You)",
                            textContent:
                                "Proin sed diam volutpat at nunc tristique sed. Eros, sit pellentesque tristique sit viverra nibh. Tellus odio eu ultrices quisque a praesent.",
                            time: "14:01",
                            avatar: "assets/images/message_avatar.png",
                          ),
                          const MessageBubbleOther(
                            from: "Adam Smith",
                            textContent:
                                "Proin sed diam volutpat at nunc tristique sed. Eros, sit pellentesque tristique sit viverra nibh. Tellus odio eu ultrices quisque a praesent.",
                            time: "14:01",
                            avatar: "assets/images/message_avatar.png",
                          ),
                          const MessageBubbleMe(
                            from: "Samuel Jackson (You)",
                            textContent:
                                "Proin sed diam volutpat at nunc tristique sed. Eros, sit pellentesque tristique sit viverra nibh. Tellus odio eu ultrices quisque a praesent.",
                            time: "14:01",
                            avatar: "assets/images/message_avatar.png",
                          ),
                          const MessageBubbleOther(
                            from: "Adam Smith",
                            textContent:
                                "Proin sed diam volutpat at nunc tristique sed. Eros, sit pellentesque tristique sit viverra nibh. Tellus odio eu ultrices quisque a praesent.",
                            time: "14:01",
                            avatar: "assets/images/message_avatar.png",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 120),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                      const SizedBox(width: 6),
                      Material(
                        borderRadius: BorderRadius.circular(90),
                        color: AppTheme.primaryColor,
                        child: SizedBox(
                          width: 47,
                          height: 47,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                                SvgPicture.asset("assets/icons/send_icom.svg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
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
