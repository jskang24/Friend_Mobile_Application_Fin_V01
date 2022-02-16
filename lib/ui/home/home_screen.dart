import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:friend_mobile/ui/dashboard/dashboard_screen.dart';
import 'package:friend_mobile/ui/home/home_store.dart';
import 'package:friend_mobile/ui/home/widgets/custom_bottom_bar.dart';
import 'package:friend_mobile/ui/messages/messages_screen.dart';
import 'package:friend_mobile/ui/search/search_screen.dart';
import 'package:friend_mobile/ui/share_post/share_post_screen.dart';
import 'package:friend_mobile/ui/share_story/share_story_screen.dart';
import 'package:friend_mobile/ui/user_profile/user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.homeScreenStore,
  }) : super(key: key);
  final HomeScreenStore homeScreenStore;
  static const String route = "home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget getHomeView(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const UserProfileScreen();
      case 2:
        return const MessagesScreen();
      case 3:
        return const SearchScreen();
      default:
        return Container();
    }
  }

  void onSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, SharePostScreen.route);
        break;
      case 1:
        Navigator.pushNamed(context, ShareStoryScreen.route);
        break;
      default:
        Navigator.pushNamed(context, ShareStoryScreen.route);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: widget.homeScreenStore.homeIndex == 0
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 72),
                  child: FloatingActionButton(
                    onPressed: null,
                    backgroundColor: const Color(0xff8E12AA),
                    foregroundColor: Colors.white,
                    child: PopupMenuButton<int>(
                      child: const Icon(
                        Icons.add,
                        size: 32,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                      onSelected: onSelected,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 0,
                          child: Text("Share Post"),
                        ),
                        const PopupMenuItem(
                          value: 1,
                          child: Text("Share Story"),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
        body: Stack(
          children: [
            PageTransitionSwitcher(
              reverse: false,
              transitionBuilder: (Widget child1, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return SharedAxisTransition(
                  fillColor: Colors.transparent,
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.scaled,
                  child: child1,
                );
              },
              child: getHomeView(
                widget.homeScreenStore.homeIndex,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomBottomBar(
                store: widget.homeScreenStore,
              ),
            ),
          ],
        ),
      );
    });
  }
}
