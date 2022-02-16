import 'package:flutter/material.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberListScreen extends StatefulWidget {
  String name = "";
  // const MemberListScreen({Key? key}) : super(key: key);
  static const String route = 'MembersList';
  MemberListScreen({required this.name});
  @override
  _MemberListScreenState createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  List userList = [];
  List userInfo = [];
  retrieve() async {
    var document = await FirebaseFirestore.instance
        .collection('Communities')
        .doc(widget.name);
    document.get().then((document) {
      setState(() {
        userList = document['userlist'];
        userList = userList.sublist(
          1,
        );
        for (var uid in userList) {
          // print("WTF");
          var docs = FirebaseFirestore.instance.collection('Users').doc(uid);
          docs.get().then((docs) {
            setState(() {
              String name = docs['name'];
              String surName = docs['surname'];
              String country = docs['country'];
              String photo = docs['photo'];
              String age = docs['age'].toString();
              List user = [name, surName, country, photo, age];
              userInfo.add(user);
              // print(user);
            });
          });
        }
        print(userInfo);
      });
    });
    // print(userList);

    // print(userInfo);
  }

  @override
  void initState() {
    retrieve();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: Colors.white,
          leadingWidth: 28,
          centerTitle: false,
          elevation: 0,
          actions: [
            IconButton(
              splashColor: Colors.white38,
              splashRadius: 20,
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.name),
              Text(
                "Members List",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        body: Stack(children: [
          ListView.builder(
              itemCount: userList.length,
              itemBuilder: (BuildContext context, int ind) {
                // print(userList[ind]);
                // print(users[posts[index]["uid"]]["name"]);
                try {
                  return Column(children: [
                    MemberListTile(
                      name: userInfo[ind][0] + " " + userInfo[ind][1],
                      age: userInfo[ind][4],
                      imgUrl: userInfo[ind][3],
                      index: ind,
                      country: userInfo[ind][2],
                    ),
                    SizedBox(height: 4),
                  ]);
                } catch (e) {
                  return Container();
                }
              })
        ]));
  }
}

class MemberListTile extends StatelessWidget {
  const MemberListTile({
    Key? key,
    required this.name,
    required this.age,
    required this.imgUrl,
    required this.index,
    required this.country,
  }) : super(key: key);
  final String name, age, country, imgUrl;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/user1png.png"),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 13,
                    width: 18,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.green),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    country,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Text(
                "$age years old",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }
}
