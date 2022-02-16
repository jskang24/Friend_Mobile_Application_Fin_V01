//TODO: 1. Email verify, 2. Email already in use display

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/signup/profile_pic_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  static const String route = "signup";
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  String displayDate = "Date of Birth";
  late DateTime picked;
  String countryName = "Greece";
  bool check = false;
  bool checkDate = false;
  var users = [];
  late FToast fToast;

  emailCheck() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((querySnapshot) {
      setState(() {
        users = querySnapshot.docs.map((doc) => doc.data()['email']).toList();
      });
    });
  }

  void initState() {
    fToast = FToast();
    fToast.init(context);
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("This email is already signed up to an account"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showToast2() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Password should be at least 8 characters long"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
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
            title: SvgPicture.asset("assets/images/signup_title.svg"),
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
                          validator: (String? value) {
                            if (value!.isEmpty) return 'Please enter some text';
                            return null;
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            label: const Text("Name"),
                            hintText: "John",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) return 'Please enter some text';
                            return null;
                          },
                          controller: surnameController,
                          decoration: InputDecoration(
                            label: const Text("Surname"),
                            hintText: "Doe",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) return 'Please enter some text';
                            return null;
                          },
                          controller: userController,
                          decoration: InputDecoration(
                            label: const Text("Email"),
                            hintText: "email@example.com",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (String? value) {
                            if (value!.length < 9) {
                              _showToast2();

                              return "Password should be at least 8 characters long";
                            }
                            return null;
                          },
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            label: const Text("Password"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: displayDate,
                            // prefixIconConstraints: BoxConstraints(
                            //   maxHeight: 20,
                            //   maxWidth: 20,
                            // ),
                            suffixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Image.asset(
                                  "assets/images/calender_icon.png"),
                              onPressed: () async {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime(1997, 1, 1),
                                  firstDate: DateTime(1947),
                                  lastDate: DateTime.now(),
                                  helpText: "Choose Your Birth Date",
                                ).then((pickedDate) {
                                  setState(() {
                                    checkDate = true;
                                    // print(pickedDate);
                                    displayDate = DateFormat('yyyy-MM-dd')
                                        .format(pickedDate!);
                                    picked = pickedDate;
                                  });
                                });
                              },
                              splashRadius: 16,
                            ),
                            label: Text("$displayDate"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CountryPickerDropdown(
                          itemHeight: 72,
                          hint: const Text("Nationality"),
                          underline: Container(
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Transform.translate(
                              offset: const Offset(10, -7),
                              child: const Text(
                                "   Nationality   ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          initialValue: 'GR',
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
                          itemBuilder: _buildDropdownItem,
                          priorityList: [
                            CountryPickerUtils.getCountryByIsoCode('GB'),
                            CountryPickerUtils.getCountryByIsoCode('CN'),
                          ],
                          sortComparator: (Country a, Country b) =>
                              a.isoCode.compareTo(b.isoCode),
                          onValuePicked: (Country country) {
                            setState(() {
                              countryName = country.name;
                              print(countryName);
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Checkbox(
                              value: check,
                              onChanged: (value) {
                                setState(() {
                                  check = !check;
                                });
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      "I have read  ",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Terms and Conditions",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.secondaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      "and  ",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Privacy Policy",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.secondaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 28),
                        GestureDetector(
                          onTap: () async {
                            await emailCheck();
                            if (users.contains(userController.text)) {
                              _showToast();
                            } else {
                              if (_formKey.currentState!.validate() && check) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ProfilePicSelectScreen(
                                            name: nameController.text,
                                            surname: surnameController.text,
                                            user: userController.text,
                                            password: passwordController.text,
                                            picked: DateFormat('yyyy-MM-dd')
                                                .format(picked),
                                            country: countryName)));
                              }
                            }
                          },
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                "Signup",
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
