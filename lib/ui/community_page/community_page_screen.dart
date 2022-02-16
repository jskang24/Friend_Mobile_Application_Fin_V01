import 'package:flutter/material.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/community_wall/wall_community_screen.dart';
import 'package:friend_mobile/ui/home/home_store.dart';
import 'package:friend_mobile/ui/home/widgets/custom_bottom_bar.dart';
import 'package:friend_mobile/ui/member_near_you/member_near_screen.dart';
import 'package:friend_mobile/ui/members_list/members_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CommunityPageScreen extends StatefulWidget {
  String name = "";
  CommunityPageScreen({required this.name});
  static const String route = "CommunityPage";
  @override
  _CommunityPageScreenState createState() => _CommunityPageScreenState();
}

class _CommunityPageScreenState extends State<CommunityPageScreen> {
  late FToast fToast;

  var userList = [];
  var userInfo = [];
  var numOfUsers = 0;
  int hobbiesnum = 10;
  bool joined = true;

  static const _insets = 16.0;
  BannerAd? _inlineAdaptiveAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  late Orientation _currentOrientation;

  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  void _loadAd() async {
    await _inlineAdaptiveAd?.dispose();
    setState(() {
      _inlineAdaptiveAd = null;
      _isLoaded = false;
    });

    // Get an inline adaptive size for the current orientation.
    AdSize size = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
        _adWidth.truncate());

    _inlineAdaptiveAd = BannerAd(
      // TODO: replace this test ad unit with your own ad unit.
      adUnitId: 'ca-app-pub-2504170753260400/5217308713',
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          print('Inline adaptive banner loaded: ${ad.responseInfo}');

          // After the ad is loaded, get the platform ad size and use it to
          // update the height of the container. This is necessary because the
          // height can change after the ad is loaded.
          BannerAd bannerAd = (ad as BannerAd);
          final AdSize? size = await bannerAd.getPlatformAdSize();
          if (size == null) {
            print('Error: getPlatformAdSize() returned null for $bannerAd');
            return;
          }

          setState(() {
            _inlineAdaptiveAd = bannerAd;
            _isLoaded = true;
            _adSize = size;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Inline adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    await _inlineAdaptiveAd!.load();
  }

  retrieve() async {
    // dir = "assets/images/" + widget.name + ".jpg";
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      setState(() {
        hobbiesnum = doc['hobbies'].length;
      });
    });
    var document = await FirebaseFirestore.instance
        .collection('Communities')
        .doc(widget.name);
    document.get().then((document) {
      setState(() {
        userList = document['userlist'];
        userList = userList.sublist(
          1,
        );
        if (userList.contains(FirebaseAuth.instance.currentUser!.uid)) {
          joined = true;
        } else {
          joined = false;
        }
        for (var uid in userList) {
          // print("WTF");
          FirebaseFirestore.instance.collection('Users').get().then((docs) {
            setState(() {
              // String photo = ;
            });
          });
        }
      });
    });
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
          Text("You have already joined 5 communities!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }

  join() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      var tmpList = doc['hobbies'];
      tmpList.add(widget.name);
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'hobbies': tmpList});
    });
    await FirebaseFirestore.instance
        .collection("Communities")
        .doc(widget.name)
        .get()
        .then((doc) {
      var tmpList = doc['userlist'];
      tmpList.add(FirebaseAuth.instance.currentUser!.uid);
      FirebaseFirestore.instance
          .collection("Communities")
          .doc(widget.name)
          .update({'userlist': tmpList});
    });
    setState(() {
      joined = true;
    });
  }

  unjoin() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      var tmpList = doc['hobbies'];
      tmpList.remove(widget.name);
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'hobbies': tmpList});
    });
    await FirebaseFirestore.instance
        .collection("Communities")
        .doc(widget.name)
        .get()
        .then((doc) {
      var tmpList = doc['userlist'];
      tmpList.remove(FirebaseAuth.instance.currentUser!.uid);
      FirebaseFirestore.instance
          .collection("Communities")
          .doc(widget.name)
          .update({'userlist': tmpList});
    });
    setState(() {
      joined = false;
    });
  }

  void initState() {
    retrieve();
    fToast = FToast();
    fToast.init(context);
  }

  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _inlineAdaptiveAd != null &&
            _isLoaded &&
            _adSize != null) {
          return Align(
              child: Container(
            width: _adWidth,
            height: _adSize!.height.toDouble(),
            child: AdWidget(
              ad: _inlineAdaptiveAd!,
            ),
          ));
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("assets/images/community_bg2.png"),
          // Image.asset("assets/images/community_bg1.png"),
          SizedBox(
              child: Image.asset("assets/images/" + widget.name + ".jpg",
                  width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 20 * 7),
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 210),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (joined == true) {
                              unjoin();
                            } else {
                              if (hobbiesnum < 5) {
                                join();
                              } else {
                                _showToast();
                              }
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              color: (joined == true)
                                  ? Colors.grey
                                  : AppTheme.secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            child: Center(
                              child: (joined == true)
                                  ? Text(
                                      "Joined",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )
                                  : Text(
                                      "Join",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 28),
                    OrientationBuilder(
                      builder: (context, orientation) {
                        if (_currentOrientation == orientation &&
                            _inlineAdaptiveAd != null &&
                            _isLoaded &&
                            _adSize != null) {
                          return Align(
                              child: Container(
                            width: _adWidth,
                            height: _adSize!.height.toDouble(),
                            child: AdWidget(
                              ad: _inlineAdaptiveAd!,
                            ),
                          ));
                        }
                        // Reload the ad if the orientation changes.
                        if (_currentOrientation != orientation) {
                          _currentOrientation = orientation;
                          _loadAd();
                        }
                        return Container();
                      },
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        if (joined) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MemberListScreen(name: widget.name)));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(16),
                        // height: 94,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Members List  ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      userList.length.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        margin: const EdgeInsets.only(left: 96),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade100,
                                            width: 5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/user2.png"),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        margin: const EdgeInsets.only(left: 72),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade100,
                                            width: 5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/user2.png"),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        margin: const EdgeInsets.only(left: 48),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade100,
                                            width: 5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/user2.png"),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        margin: const EdgeInsets.only(left: 24),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade100,
                                            width: 5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/user2.png"),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade100,
                                            width: 5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/user2.png"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppTheme.primaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        if (joined) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CommunityWallScreen(name: widget.name)));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(16),
                        height: 94,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      "Community Wall",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Share, read, watch contents about\nthis community.",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppTheme.primaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        if (joined) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MembersNearScreen(name: widget.name)));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(16),
                        height: 94,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      "Near members to you",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Find and contact with members within\n80km range",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppTheme.primaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: SafeArea(child: BackButton()),
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

  void dispose() {
    super.dispose();
    _inlineAdaptiveAd?.dispose();
  }
}
