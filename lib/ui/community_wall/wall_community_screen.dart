import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/home/home_store.dart';
import 'package:friend_mobile/ui/home/widgets/custom_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friend_mobile/ui/view_story/view_story.dart';

class CommunityWallScreen extends StatefulWidget {
  String name = "";
  CommunityWallScreen({required this.name});
  static const String route = "CommunityWall";
  @override
  _CommunityWallScreenState createState() => _CommunityWallScreenState();
}

class _CommunityWallScreenState extends State<CommunityWallScreen> {
  var posts = [];
  var users = [];
  var members = [];
  var storyUserList = [];
  var name = [];
  var pfp = [];
  String spfp = "";
  final FirebaseAuth auth = FirebaseAuth.instance;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  void _onRefresh() async {
    retrieve();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void dispose() {
    super.dispose();
  }

  void initState() {
    retrieveUsersWithStories();
    retrieve();
    for (var i = 0; i < posts.length; i++) {
      retrieveName(posts[i]['uid']);
    }
  }

  retrieveUsersWithStories() async {
    await FirebaseFirestore.instance
        .collection('Communities')
        .doc(widget.name)
        .collection('Stories')
        .get()
        .then((querySnapshot) {
      for (var i in querySnapshot.docs.map((doc) => doc.data()).toList()) {
        if (storyUserList.contains(i['uid']) == false) {
          setState(() {
            storyUserList.add(i['uid']);
          });
        }
      }
      setState(() {
        storyUserList.removeLast();
      });
      print(storyUserList);
    });
  }

  void _onLoading() async {
    retrieve();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

//    items.add((items.length + 1).toString());
    // if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  retrieveStoryPFP(String uid) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      // print(documentSnapshot);
      setState(() {
        spfp = documentSnapshot['photo'];
      });
    });
  }

  retrieveName(String uid) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      // print(documentSnapshot);
      setState(() {
        pfp.add(documentSnapshot['photo']);
        name.add(documentSnapshot['name'] + " " + documentSnapshot['surname']);
      });
    });
  }

  retrieve() async {
    await FirebaseFirestore.instance
        .collection('Communities')
        .doc(widget.name)
        .collection('Posts')
        .limit(100)
        .get()
        .then((querySnapshot) {
      setState(() {
        posts = querySnapshot.docs.map((doc) => doc.data()).toList();
        posts.removeLast();
      });
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((querySnapshot) {
      setState(() {
        users = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    });

    for (var i = 0; i < posts.length; i++) {
      retrieveName(posts[i]['uid']);
    }
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
                "Wall",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          // enablePullUp: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: Stack(
            children: [
              Column(children: [
                SizedBox(
                    height: 78,
                    child: Row(children: [
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: storyUserList.length,
                          itemBuilder: (BuildContext context, int index) {
                            retrieveStoryPFP(storyUserList[index]);
                            return GestureDetector(
                              onTap: (() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewStory(
                                          uid: storyUserList[index],
                                          community: widget.name)),
                                );
                              }),
                              child: StoryTile(isViewed: false, image: spfp),
                            );
                          })
                    ])

                    // ListView(
                    //   shrinkWrap: true,
                    //   physics: const BouncingScrollPhysics(),
                    //   scrollDirection: Axis.horizontal,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: (() {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => Home()),
                    //         );
                    //       }),
                    //       child: StoryTile(isViewed: false),
                    //     ),
                    //     VerticalDivider(
                    //       width: 3,
                    //       endIndent: 12,
                    //       indent: 12,
                    //       color: Colors.grey,
                    //     ),
                    //     StoryTile(isViewed: false),
                    //     StoryTile(isViewed: false),
                    //     StoryTile(isViewed: true),
                    //     StoryTile(isViewed: true),
                    //     StoryTile(isViewed: false),
                    //   ],
                    // ),
                    ),
                const Divider(
                  color: Colors.black45,
                  height: 2,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 3 / 4,
                    child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          //print(index);
                          // print(users[posts[index]["uid"]]["name"]);
                          // retrieveName(posts[index]['uid']);
                          try {
                            return Column(children: [
                              CommunityPost(
                                  name: name[index],
                                  community: widget.name,
                                  post: posts[index]["caption"],
                                  time: posts[index]["timestamp"]
                                      .split("-")
                                      .sublist(0, 3)
                                      .join('.'),
                                  comments: posts[index]["comment"].length,
                                  likes: posts[index]["like"],
                                  images: pfp[index],
                                  postName: posts[index]['postName']),
                              SizedBox(height: 4),
                            ]);
                          } catch (e) {
                            return Container();
                          }
                        })),
              ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomBottomBar(
                  store: HomeScreenStore(),
                ),
              )
            ],
          ),
        ));
  }
}

class CommunityPost extends StatefulWidget {
  const CommunityPost(
      {Key? key,
      required this.name,
      required this.community,
      required this.post,
      required this.time,
      required this.comments,
      required this.likes,
      required this.images,
      required this.postName})
      : super(key: key);
  final String name, community, post, time, images, postName;
  final int comments, likes;
  @override
  _CommunityPostState createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPost> {
  final commentController = TextEditingController();
  var comments = [];
  String userImg = "asdf";
  bool visitedlike = false;
  bool visitedunlike = true;

  onCommented(message) {
    var tmpcomments = [];
    FirebaseFirestore.instance
        .collection("Communities")
        .doc(widget.community)
        .collection("Posts")
        .doc(widget.postName)
        .get()
        .then((value) {
      tmpcomments = value['comment'];
      tmpcomments.add(message);
      FirebaseFirestore.instance
          .collection("Communities")
          .doc(widget.community)
          .collection("Posts")
          .doc(widget.postName)
          .update({"comment": tmpcomments});
      setState(() {
        comments = tmpcomments;

        print("ASDFASDF: " + comments.toString());
      });
    });
    commentController.clear();
  }

  bool liked = false;

  void initState() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        userImg = value['photo'];
      });
      if (value['likedposts'].contains(widget.postName)) {
        setState(() {
          liked = true;
        });
      } else {
        setState(() {
          liked = false;
        });
      }
    });
  }

  like() async {
    setState(() {
      liked = true;
      visitedlike = true;
      visitedunlike = false;
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      var likedpost = doc['likedposts'];
      likedpost.add(widget.postName);
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"likedposts": likedpost});
    });
    var likes = widget.likes + 1;
    await FirebaseFirestore.instance
        .collection("Communities")
        .doc(widget.community)
        .collection("Posts")
        .doc(widget.postName)
        .update({'like': likes});
  }

  unlike() async {
    setState(() {
      liked = false;
      visitedunlike = true;
      visitedlike = true;
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      var likedpost = doc['likedposts'];
      print(likedpost);
      likedpost.remove(widget.postName);
      print(likedpost);
      FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"likedposts": likedpost});
    });
    var likes = widget.likes - 1;
    await FirebaseFirestore.instance
        .collection("Communities")
        .doc(widget.community)
        .collection("Posts")
        .doc(widget.postName)
        .update({'like': likes});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.images),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "   •  ${widget.time}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "shared a post on",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.community,
                        style: const TextStyle(
                          color: AppTheme.secondaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      widget.post,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            if (liked == false) {
                              await like();
                            } else {
                              await unlike();
                            }
                          },
                          child: Container(
                            height: 36,
                            width: 120,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/icons/like.svg"),
                                  const SizedBox(width: 20),
                                  liked
                                      ? visitedlike
                                          ? Text(
                                              "${widget.likes + 1}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            )
                                          : Text(
                                              "${widget.likes}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            )
                                      : visitedlike
                                          ? Text(
                                              "${widget.likes}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            )
                                          : Text(
                                              "${widget.likes}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            )
                                ],
                              ),
                            ),
                          )),
                      const SizedBox(width: 12),
                      Container(
                        height: 36,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: AppTheme.secondaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.share,
                              color: AppTheme.secondaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "0",
                              style: const TextStyle(
                                  color: AppTheme.secondaryColor, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.66,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Comments • ${widget.comments}",
                      style: const TextStyle(
                        color: AppTheme.secondaryColor,
                        fontSize: 16,
                      ),
                    ),
                    // Transform.rotate(
                    //   angle: -pi / 2,
                    //   child: const Icon(
                    //     Icons.arrow_forward_ios_outlined,
                    //     color: AppTheme.secondaryColor,
                    //     size: 20,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 70),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  print(comments[index]);
                  return Container(child: Text(comments[index]));
                }),
          ),
          Row(
            children: [
              const SizedBox(width: 12),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(userImg),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Row(children: [
                SizedBox(
                  width: 180,
                  child: CupertinoTextField(
                    onSubmitted: onCommented,
                    controller: commentController,
                    maxLines: null,
                    expands: true,
                    placeholder: "write comment here ...",
                  ),
                ),
                const SizedBox(width: 0),
                MaterialButton(
                  onPressed: () {
                    onCommented(commentController.text);
                  },
                  shape: CircleBorder(),
                  // borderRadius: BorderRadius.circular(90),
                  color: AppTheme.primaryColor,
                  child: SizedBox(
                    width: 47,
                    height: 47,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset("assets/icons/send_icom.svg"),
                    ),
                  ),
                ),
              ])
            ],
          )
        ],
      ),
    );
  }
}

class StoryTile extends StatelessWidget {
  StoryTile({
    Key? key,
    required this.isViewed,
    required this.image,
  }) : super(key: key);

  final bool isViewed;
  String image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              border: isViewed
                  ? Border.all(color: Colors.grey, width: 3)
                  : Border.all(color: AppTheme.primaryColor, width: 3),
              image: DecorationImage(
                image: NetworkImage(image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
