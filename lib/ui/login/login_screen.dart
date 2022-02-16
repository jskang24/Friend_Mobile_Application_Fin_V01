import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friend_mobile/ui/home/home_screen.dart';
import 'package:friend_mobile/ui/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friend_mobile/ui/google_signup/signup_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String route = "login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var data = [];
  var usersid = [];

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Future<UserCredential> signInWithFacebook() async {

  // }

  Future<void> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      if (FirebaseAuth.instance.currentUser != null) {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection("Users").get();
        data = querySnapshot.docs.map((doc) => doc.data()).toList();
        for (var i = 0; i < data.length; i++) {
          usersid.add(data[i]["uid"]);
        }

        if (usersid.contains(FirebaseAuth.instance.currentUser!.uid)) {
          Navigator.pushNamed(context, HomeScreen.route);
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GoogleSignupScreen(
                  email: FirebaseAuth.instance.currentUser!.email.toString())));
        }
      }
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Sign In ${user!.uid} with Google'),
      // ));
    } catch (e) {
      print(e);
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Failed to sign in with Google: $e'),
      //   ),
      // );
    }
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: userController.text,
        password: passwordController.text,
      ))
          .user!;

      // Scaffold.of(context)
      //     .showSnackBar(SnackBar(content: Text('${user.email} signed in')));
    } catch (e) {
      print("ASDF");
      // Scaffold.of(context)
      //     .showSnackBar(SnackBar(content: Text('Failed to sign in')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SvgPicture.asset("assets/images/top_bg.svg"),
            Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
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
                  const SizedBox(height: 16),
                  const Text(
                    "Connecting",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Social Communities",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "around the World",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 124),
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      InkWell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xffFE6F6F),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/images/google.svg"),
                                const SizedBox(width: 14),
                                const Text(
                                  "Login with\nGoogle",
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 14,
                                    color: Color(0xffFE6F6F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            await signInWithGoogle();
                            // if (FirebaseAuth.instance.currentUser != null) {
                            //   Navigator.pushReplacementNamed(
                            //       context, HomeScreen.route);
                            // } else {
                            //   Navigator.pushReplacementNamed(
                            //       context, SignupScreen.route);
                            // }
                          }),
                      const SizedBox(width: 10),
                      InkWell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xff7A9BED),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/images/facebook.svg"),
                                const SizedBox(width: 14),
                                const Text(
                                  "Login with\nFacebook",
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 14,
                                    color: Color(0xff7A9BED),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            await signInWithGoogle();
                            // signInWithFacebook();
                          }),
                    ],
                  ),
                  const SizedBox(height: 55),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty)
                                return 'Please enter some text';
                              return null;
                            },
                            controller: userController,
                            decoration: InputDecoration(
                              label: const Text("Email"),
                              hintText: "email@example.com",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty)
                                return 'Please enter some text';
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
                          const SizedBox(height: 28),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await _signInWithEmailAndPassword();
                                if (FirebaseAuth.instance.currentUser != null) {
                                  Navigator.pushReplacementNamed(
                                      context, HomeScreen.route);
                                }
                              }
                              //
                            },
                            child: Container(
                              height: 54,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have an acoount?",
                        style: TextStyle(
                            fontFamily: "SFPro",
                            color: Color(0xffC0C0C0),
                            letterSpacing: 1.2),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignupScreen.route);
                        },
                        child: const Text(
                          "Signup",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: "SFPro",
                            color: Color(0xff8E12AA),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
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
