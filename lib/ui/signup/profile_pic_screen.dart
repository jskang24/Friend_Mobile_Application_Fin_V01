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

class ProfilePicSelectScreen extends StatefulWidget {
  String name = "";
  String surname = "";
  String user = "";
  String password = "";
  String picked = "";
  String country = "";
  ProfilePicSelectScreen({
    required this.name,
    required this.surname,
    required this.user,
    required this.password,
    required this.picked,
    required this.country,
  });
  static const String route = "signup_pic";
  @override
  State<StatefulWidget> createState() => _ProfilePicSelectScreenState();
}

class _ProfilePicSelectScreenState extends State<ProfilePicSelectScreen> {
  final picker = ImagePicker();
  String defaultImage = "assets/images/default_profile.png";
  String _imageFile = "assets/images/default_profile.png";

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
                    CupertinoButton(
                      child: const Text(
                        "SKIP",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HobbiesSelectScreen(
                                name: widget.name,
                                surname: widget.surname,
                                email: widget.user,
                                password: widget.password,
                                picked: widget.picked,
                                country: widget.country,
                                imageLocalPath: _imageFile)));
                      },
                    ),
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      borderRadius: BorderRadius.circular(10),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HobbiesSelectScreen(
                                name: widget.name,
                                surname: widget.surname,
                                email: widget.user,
                                password: widget.password,
                                picked: widget.picked,
                                country: widget.country,
                                imageLocalPath: _imageFile)));
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
