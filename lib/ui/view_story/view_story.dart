import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friend_mobile/ui/community_wall/wall_community_screen.dart';

class ViewStory extends StatefulWidget {
  String uid;
  String community;

  ViewStory({Key? key, required this.uid, required this.community})
      : super(key: key);

  @override
  _ViewStory createState() => _ViewStory();
}

class _ViewStory extends State<ViewStory> {
  final StoryController controller = StoryController();
  List<StoryItem> stories = [];
  initStory() {
    stories.add(StoryItem.text(title: "", backgroundColor: Colors.white));
  }

  void initState() {
    initStory();
    addStoryItems();
  }

  addStoryItems() async {
    await FirebaseFirestore.instance
        .collection('Communities')
        .doc(widget.community)
        .collection('Stories')
        .where("uid", isEqualTo: widget.uid)
        .get()
        .then((querySnapshot) {
      var docList = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        for (var i in docList) {
          stories.add(StoryItem.inlineImage(
            url: i['image'],
            controller: controller,
          ));
        }
        stories.removeAt(0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(""),
      ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: StoryView(
            storyItems: stories,
            onStoryShow: (s) {},
            onComplete: () {
              Navigator.pop(
                context,
              );
            },
            //You can place your progress position top or bottom
            progressPosition: ProgressPosition.bottom,
            repeat: false,
            controller: controller,
          ),
        )
      ]),
    );
  }
}
