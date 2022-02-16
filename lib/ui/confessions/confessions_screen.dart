import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:friend_mobile/ui/home/home_store.dart';
import 'package:friend_mobile/ui/home/widgets/custom_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfessionScreen extends StatefulWidget {
  const ConfessionScreen({Key? key}) : super(key: key);
  static const String route = "confessions";
  @override
  _ConfessionScreenState createState() => _ConfessionScreenState();
}

class _ConfessionScreenState extends State<ConfessionScreen> {
  var confessions = [];
  final _textController = new TextEditingController();

  void onMessageSubmitted(message) {
    FirebaseFirestore.instance.collection("Confessions").add({
      "content": message,
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        shadowColor: Colors.black26,
        backgroundColor: Colors.white,
        toolbarHeight: 96,
        leadingWidth: 24,
        title: Column(
          children: [
            SvgPicture.asset("assets/images/signup_title.svg"),
            const Text(
              "Confess your secrets as anonymous",
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Flexible(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Confessions")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      var confessions = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Text(confessions[index]['content']),
                            );
                          });
                    }
                  })),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: onMessageSubmitted,
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: "Write confess here ... (Anonymous)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      MaterialButton(
                        onPressed: () {
                          onMessageSubmitted(_textController.text);
                        },
                        shape: CircleBorder(),
                        // borderRadius: BorderRadius.circular(90),
                        color: AppTheme.primaryColor,
                        child: SizedBox(
                          width: 47,
                          height: 47,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                                SvgPicture.asset("assets/icons/send_icom.svg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomBottomBar(
                  store: HomeScreenStore(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
