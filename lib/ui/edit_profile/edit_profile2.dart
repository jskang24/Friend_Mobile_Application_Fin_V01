import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/signup/hobbies_select_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';

class ProfilePicEditScreen extends StatefulWidget {
  String name = "";
  String surname = "";
  String user = "";
  String password = "";
  String picked = "";
  String country = "";
  ProfilePicEditScreen({Key? key}) : super(key: key);
  static const String route = "signup_pic";
  @override
  State<StatefulWidget> createState() => _ProfilePicEditScreenState();
}

class _ProfilePicEditScreenState extends State<ProfilePicEditScreen> {
  final picker = ImagePicker();
  String defaultImage = "assets/images/default_profile.png";
  String _imageFile = "assets/images/default_profile.png";
  String imageNetworkPath = "";

  uploadProfile(String filePath) async {
    var date = DateTime.now();

    File file = File(filePath);

    String uname = await FirebaseAuth.instance.currentUser!.uid;
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
    String imagename = "profile_" + uname + "_" + time;

    // print(time);
    await firebase_storage.FirebaseStorage.instance
        .ref('profilePic/${imagename}.jpg')
        .putFile(file);

    String downloadurl = await firebase_storage.FirebaseStorage.instance
        .ref('profilePic/${imagename}.jpg')
        .getDownloadURL();
    setState(() {
      imageNetworkPath = downloadurl;
      print("Local path: " + imageNetworkPath);
    });

    await FirebaseFirestore.instance.collection('Users').doc(uname).update({
      'photo': imageNetworkPath, // will always be null
    });
  }

  pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile.path;
      } else {
        _imageFile = defaultImage;
      }
      print(_imageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                toolbarHeight: 72,
                title: SvgPicture.asset(
                  "assets/images/signup2_title.svg",
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 128,
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: 120,
                      width: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        image: DecorationImage(
                            image: _imageFile ==
                                    "assets/images/default_profile.png"
                                ? AssetImage(defaultImage) as ImageProvider
                                : FileImage(File(_imageFile)),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffE7E7E7), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Upload",
                        style: TextStyle(fontSize: 16),
                      ),
                      InkResponse(
                        onTap: () {
                          pickImage();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          height: 32,
                          width: 32,
                          color: Colors.transparent,
                          child: Image.asset(
                            "assets/images/upload_icon.png",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Maximum 700KB",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.white,
              child: SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      borderRadius: BorderRadius.circular(10),
                      onPressed: () async {
                        if (_imageFile.substring(0, 5) == 'asset') {
                          setState(() {
                            imageNetworkPath =
                                "https://firebasestorage.googleapis.com/v0/b/friendapp-1be2f.appspot.com/o/profilePic%2Fdefault_profile.png?alt=media&token=2a4c2400-0d52-4445-b6a0-a9235a93e20b";
                          });
                        } else {
                          await uploadProfile(_imageFile);
                        }
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: const [
                          Text(
                            "Done",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
