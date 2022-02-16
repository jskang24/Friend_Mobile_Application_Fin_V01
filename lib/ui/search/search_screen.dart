import 'package:flutter/material.dart';
import 'package:friend_mobile/ui/search/widgets/search_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:search_page/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class commName {
  String name;
  int members;
  commName(this.name, this.members);
}

class _SearchScreenState extends State<SearchScreen> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Communities').snapshots();
  var data = [];
  List<commName> communities = [];

  retrieve() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Communities").get();
    data = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (var i = 0; i < data.length; i++) {
      communities.add(commName(data[i]["name"], data[i]["userlist"].length));
    }
  }

  @override
  void initState() {
    retrieve();
  }

  @override
  Widget build(BuildContext context) {
    final searchquery = new TextEditingController();

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: Text("Loading")));
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 0,
            elevation: 0,
            bottom: PreferredSize(
              child: Container(
                color: Colors.white,
                height: 120,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
                  child: GestureDetector(
                    child: TextField(
                      onTap: () => showSearch(
                        context: context,
                        delegate: SearchPage<commName>(
                          onQueryUpdate: (s) => print(s),
                          items: communities,
                          searchLabel: 'Search Communities',
                          suggestion: Center(
                            child: Text('Filter Communities'),
                          ),
                          failure: Center(
                            child: Text('No Communities found...'),
                          ),
                          filter: (commname) => [
                            commname.name,
                          ],
                          builder: (commname) => SearchTile(
                            label: commname.name,
                            count: (commname.members - 1).toString(),
                          ),
                        ),
                      ),
                      controller: searchquery,
                      decoration: InputDecoration(
                        prefixIcon: SizedBox(
                          width: 16,
                          height: 16,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Image.asset("assets/images/search_icon.png"),
                          ),
                        ),
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              preferredSize: Size(
                MediaQuery.of(context).size.width,
                120,
              ),
            ),
          ),
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data!.docs[index];

              return SearchTile(
                label: data['name'],
                count: (data['userlist'].length - 1).toString(),
              );
            },
          ),
        );
      },
    );
  }
}
