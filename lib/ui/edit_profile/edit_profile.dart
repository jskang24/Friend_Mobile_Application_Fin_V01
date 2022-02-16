//TODO: 1. Email verify, 2. Email already in use display

import 'dart:math';
import 'package:friend_mobile/ui/edit_profile/edit_profile2.dart';
import 'package:intl/intl.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/signup/profile_pic_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friend_mobile/ui/edit_profile/edit_profile2.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);
  static const String route = "signup";
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController aboutmeController = TextEditingController();
  String displayDate = "Date of Birth";
  late DateTime picked;
  String countryName = "Greece";
  bool check = false;
  bool checkDate = false;
  String name = "";
  String surName = "";
  String country = "";
  String photo = "";
  String age = "";
  String email = "";
  String dob = "";
  String aboutme = "";

  void userInfo() async {
    var document = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    document.get().then((document) {
      setState(() {
        name = document['name'];
        surName = document['surname'];
        country = document['country'];
        photo = document['photo'];
        age = document['age'].toString();
        email = document['email'];
        dob = document['dob'];
        aboutme = document['aboutme'];
        nameController.text = name;
        surnameController.text = surName;
        aboutmeController.text = aboutme;
      });
    });
  }

  updateUser() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'name': nameController.text,
      'surname': surnameController.text,
      'aboutme': aboutmeController.text,
    });
  }

  void initState() {
    userInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 72,
            // title: SvgPicture.asset("assets/images/signup_title.svg"),
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Edit Profile")]),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 55),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          // initialValue: name,
                          validator: (String? value) {
                            if (value!.isEmpty) return 'Please enter some text';
                            return null;
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            label: Text("Name"),
                            // hintText: "John",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          // initialValue: surName,
                          validator: (String? value) {
                            if (value!.isEmpty) return 'Please enter some text';
                            return null;
                          },
                          controller: surnameController,
                          decoration: InputDecoration(
                            label: const Text("Surname"),
                            // hintText: "Doe",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          // initialValue: surName,
                          validator: (String? value) {
                            if (value!.isEmpty) return 'Please enter some text';
                            return null;
                          },
                          controller: aboutmeController,
                          decoration: InputDecoration(
                            label: const Text("About Me"),
                            // hintText: "Doe",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const SizedBox(height: 28),
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePicEditScreen()),
                            );
                          },
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                "Edit Profile Picture",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () async {
                            await updateUser();
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                "Confirm Edit Profile",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem(Country country) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 16.0,
              ),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: CountryPickerUtils.getDefaultFlagImage(country),
              ),
              const SizedBox(
                width: 8.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(country.name),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      );
}
