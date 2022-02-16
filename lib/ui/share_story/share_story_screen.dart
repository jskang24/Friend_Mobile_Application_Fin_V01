// ignore_for_file: unused_element

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/home/home_store.dart';
import 'package:friend_mobile/ui/home/widgets/custom_bottom_bar.dart';
import 'package:friend_mobile/ui/share_post/share_post_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:friend_mobile/ui/home/home_screen.dart';
import 'dart:async';
// import ''

class ShareStoryScreen extends StatefulWidget {
  const ShareStoryScreen({Key? key}) : super(key: key);
  static const String route = "shareStory";
  @override
  _ShareStoryScreenState createState() => _ShareStoryScreenState();
}

class _ShareStoryScreenState extends State<ShareStoryScreen> {
  List<dynamic> hobbiesList = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  var dummyValue = "";
  int charLength = 0;
  String imageLink = "";
  String imageNetworkPath = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController postController = TextEditingController();
  final picker = ImagePicker();

  String filePath = "";

  pickImage() async {
    var date = DateTime.now();
    String uname = FirebaseAuth.instance.currentUser!.uid;
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
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        filePath = pickedFile.path;
      });
    }
  }

  String storyName = "";

  CollectionReference post =
      FirebaseFirestore.instance.collection("Communities");

  Future<void> addUser() async {
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
    String uname = FirebaseAuth.instance.currentUser!.uid;
    String imagename = "story_" + uname + "_" + time;
    if (filePath != "") {
      var pickFile = File(filePath);
      await firebase_storage.FirebaseStorage.instance
          .ref('StoryPic/${imagename}.jpg')
          .putFile(pickFile);

      String downloadurl = await firebase_storage.FirebaseStorage.instance
          .ref('StoryPic/${imagename}.jpg')
          .getDownloadURL();
      return post.doc(dummyValue).collection("Stories").doc(storyName).set({
        'uid': auth.currentUser!.uid,
        'image': downloadurl,
        'timestamp': time,
      }).then((value) {
        print("User Added");
      }).catchError((error) => print("Failed to add user: $error"));
    } else {
      return post.doc(dummyValue).collection("Stories").doc(storyName).set({
        'uid': auth.currentUser!.uid,
        'image': "",
        'timestamp': time,
      }).then((value) {
        print("User Added");
      }).catchError((error) => print("Failed to add user: $error"));
    }
  }

  void _onChanged(String value) {
    setState(() {
      charLength = value.length;
    });
  }

  void retrieve() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        hobbiesList = documentSnapshot['hobbies'];
        dummyValue = hobbiesList[0];
        print(documentSnapshot.data());
        print(hobbiesList);
      });
    });
  }

  void initState() {
    retrieve();
    var date = DateTime.now();
    String uname = FirebaseAuth.instance.currentUser!.uid;
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
    setState(() {
      storyName = "Story_" + time + "_" + uname;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Story"),
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(32.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      DropdownButton<String>(
                        itemHeight: 72,
                        alignment: Alignment.centerLeft,
                        elevation: 1,
                        isExpanded: true,
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Transform.rotate(
                            angle: pi / 2,
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(4),
                        onChanged: (cValue) {
                          setState(
                            () {
                              dummyValue = cValue!;
                            },
                          );
                        },
                        underline: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Transform.translate(
                            offset: const Offset(10, -7),
                            child: const Text(
                              "   Which Community to Post   ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        value: dummyValue,
                        hint: const Text("Payment Type"),
                        items: hobbiesList.map(
                          (var item) {
                            return DropdownMenuItem<String>(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 56,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(item),
                                ),
                              ),
                              value: item,
                            );
                          },
                        ).toList(),
                      ),
                      // const SizedBox(height: 16),
                      // Container(
                      //   height: 111,
                      //   decoration: BoxDecoration(
                      //       border: Border.all(width: 1, color: Colors.grey),
                      //       borderRadius: BorderRadius.circular(10)),
                      //   padding: const EdgeInsets.symmetric(horizontal: 12),
                      //   child: const Center(
                      //     child: Text(
                      //       "No Content Selected",
                      //       style: TextStyle(
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                      AppIconButtom(
                        iconURL: "assets/icons/muti_image.svg",
                        label: 'Select from Gallery',
                        onTap: () {
                          pickImage();
                        },
                      ),
                      const SizedBox(height: 12),
                      AppIconButtom(
                        iconURL: "assets/icons/camera.svg",
                        label: 'Take Photo for Story',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      AppIconButtom(
                        iconURL: "assets/icons/video.svg",
                        label: 'Take Video for Story',
                        onTap: () {},
                      ),
                      const SizedBox(height: 44),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: CupertinoButton.filled(
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Share Story",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (filePath != "") {
                              print(postController.text);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => HomeScreen(
                                      homeScreenStore: HomeScreenStore()),
                                ),
                                (route) => false,
                              );
                              addUser();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomBar(
              store: HomeScreenStore(),
            ),
          )
        ],
      ),
    );
  }
}
