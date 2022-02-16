import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/home/home_store.dart';
import 'package:friend_mobile/ui/home/widgets/custom_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:friend_mobile/ui/home/home_screen.dart';
import 'dart:async';
import 'package:friend_mobile/ui/edit_profile/edit_profile.dart';

class SharePostScreen extends StatefulWidget {
  const SharePostScreen({Key? key}) : super(key: key);
  static const String route = "SharePost";
  @override
  _SharePostScreenState createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {
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

  String postName = "";

  CollectionReference post =
      FirebaseFirestore.instance.collection("Communities");

  Future<void> addUser() async {
    var date = DateTime.now();
    var posts = [];
    var comm = [];
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
    String imagename = "post_" + uname + "_" + time;
    if (filePath != "") {
      var pickFile = File(filePath);
      await firebase_storage.FirebaseStorage.instance
          .ref('postPic/${imagename}.jpg')
          .putFile(pickFile);

      String downloadurl = await firebase_storage.FirebaseStorage.instance
          .ref('postPic/${imagename}.jpg')
          .getDownloadURL();
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uname)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        posts = documentSnapshot['posts'];
        comm = documentSnapshot['postsCommunity'];
      });
      print(posts);
      posts.add(postName);
      comm.add(dummyValue);
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uname)
          .update({'posts': posts, 'postsCommunity': comm});
      return post.doc(dummyValue).collection("Posts").doc(postName).set({
        'uid': auth.currentUser!.uid,
        'image': downloadurl,
        'caption': postController.text,
        'like': 0,
        'comment': [],
        'timestamp': time,
        'postName': postName,
        'communityName': dummyValue,
      }).then((value) {
        print("User Added");
      }).catchError((error) => print("Failed to add user: $error"));
    } else {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uname)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        posts = documentSnapshot['posts'];
        comm = documentSnapshot['postsCommunity'];
      });
      print(posts);
      posts.add(postName);
      comm.add(dummyValue);
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uname)
          .update({'posts': posts, 'postsCommunity': comm});
      return post.doc(dummyValue).collection("Posts").doc(postName).set({
        'uid': auth.currentUser!.uid,
        'image': "",
        'caption': postController.text,
        'like': 0,
        'comment': [],
        'timestamp': time,
        'postName': postName,
        'communityName': dummyValue
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
      postName = "Post_" + time + "_" + uname;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Post"),
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
                      Form(
                          key: _formKey,
                          child: Column(children: [
                            DropdownButton<String>(
                              itemHeight: 72,
                              alignment: Alignment.centerLeft,
                              elevation: 1,
                              isExpanded: true,
                              icon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                              hint: const Text("Choose your community"),
                              items: hobbiesList.map(
                                (var item) {
                                  return DropdownMenuItem<String>(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
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
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: postController,
                                    validator: (String? value) {
                                      if (value!.isEmpty)
                                        return 'Please enter some text';
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    onChanged: _onChanged,
                                    maxLines: null,
                                    maxLength: 500,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    decoration: InputDecoration(
                                        counter: charLength == 0
                                            ? Container()
                                            : Text('${500 - charLength}/500'),
                                        // fillColor: Colors.white,
                                        // filled: true,
                                        border: InputBorder.none,
                                        hintText:
                                            'Write your description here ...'),
                                  ),
                                  const SizedBox(height: 8)
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            AppIconButtom(
                              iconURL: "assets/icons/image.svg",
                              label: 'Add Image to Post',
                              onTap: () {
                                pickImage();
                              },
                            ),
                            const SizedBox(height: 12),
                            AppIconButtom(
                              iconURL: "assets/icons/camera.svg",
                              label: 'Take Photo for Post',
                              onTap: () {},
                            ),
                            const SizedBox(height: 60),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: CupertinoButton.filled(
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(
                                    "Post",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    print(postController.text);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomeScreen(
                                                homeScreenStore:
                                                    HomeScreenStore()),
                                      ),
                                      (route) => false,
                                    );
                                    addUser();
                                  }
                                },
                              ),
                            )
                          ]))
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

class AppIconButtom extends StatelessWidget {
  const AppIconButtom({
    Key? key,
    required this.iconURL,
    required this.label,
    required this.onTap,
  }) : super(key: key);
  final String iconURL, label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        height: 57,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(width: 2, color: AppTheme.secondaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(iconURL),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
