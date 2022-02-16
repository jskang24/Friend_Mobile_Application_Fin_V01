//TODO: Clear login stack

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_mobile/ui/buy_premium/premium_upgrade_screen.dart';
import 'package:friend_mobile/ui/calling/calling_screen.dart';
import 'package:friend_mobile/ui/community_page/community_page_screen.dart';
import 'package:friend_mobile/ui/confessions/confessions_screen.dart';
import 'package:friend_mobile/ui/home/widgets/home_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friend_mobile/ui/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var hobbiesList = [];
  var countList = [];
  var hobbiesLength = "";
  var noOfPosts = [];
  var chat = 0;

  void postCount() async {
    for (var i in hobbiesList) {
      await FirebaseFirestore.instance
          .collection("Communities")
          .doc(i)
          .collection("Posts")
          .get()
          .then((value) {
        setState(() {
          noOfPosts.add(value.docs.map((doc) => doc.data()).toList().length);
        });
      });
    }
  }

  void setCount() {
    for (var i in hobbiesList) {
      FirebaseFirestore.instance
          .collection('Communities')
          .doc(i)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        setState(() {
          countList.add(documentSnapshot['userlist'].length);
          //print(documentSnapshot.data());
        });
      });
    }
  }

  retrieve() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        setState(() {
          hobbiesList = documentSnapshot['hobbies'];
          hobbiesLength = hobbiesList.length.toString();
          chat = documentSnapshot['Channels'].length;
          setCount();
          postCount();
          //print(documentSnapshot.data());
        });
      });
    } on Exception catch (e) {
      print(e);
      return CircularProgressIndicator();
    }
  }

  void initState() {
    retrieve();
  }

  void onSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, ConfessionScreen.route);
        break;
      case 1:
        Navigator.pushNamed(context, CallingScreen.route);
        break;
      default:
        Navigator.pushNamed(context, ConfessionScreen.route);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset("assets/images/top_bg.svg"),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                centerTitle: false,
                elevation: 0,
                backgroundColor: const Color(0xff8E12AA),
                automaticallyImplyLeading: false,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 5),
                    child: PopupMenuButton<int>(
                      child: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                      onSelected: onSelected,
                      itemBuilder: (context) => [
                        // const PopupMenuItem(
                        //   value: 0,
                        //   child: Text("Confessions"),
                        // ),
                        // const PopupMenuItem(
                        //   value: 1,
                        //   child: Text("Calling"),
                        // ),
                        PopupMenuItem(
                            value: 2,
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text("Log Out")),
                        PopupMenuItem(
                            value: 0,
                            onTap: () async {},
                            child: Text("Confessions"))
                      ],
                    ),
                  )
                ],
                title: Row(
                  children: [
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                      "assets/images/Vector.svg",
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset(
                      "assets/images/FRIEND.svg",
                      color: Colors.white,
                    ),
                  ],
                ),
                toolbarHeight: 56,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xff4ADDA6),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 5),
                        ],
                      ),
                      height: 155,
                      width: (MediaQuery.of(context).size.width * 0.5) - 42,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You\nhave",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            hobbiesLength,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "hobbies",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 5),
                        ],
                      ),
                      height: 155,
                      width: (MediaQuery.of(context).size.width * 0.5) - 42,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You\nhave",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xff8E12AA),
                            ),
                          ),
                          Text(
                            chat.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                              color: Color(0xff8E12AA),
                            ),
                          ),
                          Text(
                            "chats",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xff8E12AA),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PremiumUpgradeScreen.route);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 22),
                    height: 67,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFCE00),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 2,
                        color: const Color(0xff8C7100),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/images/premium_badge.svg"),
                        const SizedBox(width: 12),
                        const Text(
                          "Get premium and explore new features!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8C7100),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  try {
                    return HomeTile(
                      label: hobbiesList[index].toString(),
                      count1: ((countList[index] - 1).toString()),
                      count2: ((noOfPosts[index] - 1).toString()),
                      imageURL: "imageURL",
                      onTap: () {
                        Navigator.pushNamed(context, CommunityPageScreen.route);
                      },
                    );
                  } catch (e) {
                    return Container();
                  }
                }, childCount: hobbiesList.length
                    // Container(
                    //   margin: const EdgeInsets.symmetric(
                    //       horizontal: 32, vertical: 6),
                    //   height: 48,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(15),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.blueGrey.withOpacity(0.12),
                    //         offset: const Offset(2, 5),
                    //         blurRadius: 10,
                    //       ),
                    //     ],
                    //   ),
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 16.0,
                    //     vertical: 12,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       const Text(
                    //         "Expand",
                    //         style: TextStyle(
                    //           decoration: TextDecoration.underline,
                    //           fontWeight: FontWeight.bold,
                    //           color: Color(0xff8E12AA),
                    //         ),
                    //       ),
                    //       const SizedBox(width: 4),
                    //       Transform.rotate(
                    //         angle: pi / 2,
                    //         child: const Icon(
                    //           Icons.arrow_forward_ios,
                    //           size: 18,
                    //           color: Color(0xff8E12AA),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                    ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 120,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
