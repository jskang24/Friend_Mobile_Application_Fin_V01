import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_mobile/ui/login/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friend_mobile/ui/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String route = "splash";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1200),
      () {
        if (FirebaseAuth.instance.currentUser == null) {
          Navigator.pushReplacementNamed(context, LoginScreen.route);
        } else {
          Navigator.pushReplacementNamed(context, HomeScreen.route);
        }

        //LoginScreen.route if not logged in. Else, HomeScreeen.route
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4ADDA6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 160,
              child: SvgPicture.asset("assets/images/logo.svg"),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "FRIEND",
                style: TextStyle(
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  fontWeight: FontWeight.w900,
                  fontSize: 48,
                  letterSpacing: 5,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
