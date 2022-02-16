import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_mobile/ui/home/home_store.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({Key? key, required this.store}) : super(key: key);
  final HomeScreenStore store;
  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30,
        left: 32,
        right: 32,
      ),
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(60),
        child: SizedBox(
          height: 74,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomBarIcon(
                iconData: "assets/icons/home.svg",
                selectedIcon: "assets/icons/home_filled.svg",
                index: 0,
                homeScreenStore: widget.store,
              ),
              BottomBarIcon(
                iconData: "assets/icons/user.svg",
                selectedIcon: "assets/icons/user_filled.svg",
                index: 1,
                homeScreenStore: widget.store,
              ),
              BottomBarIcon(
                iconData: "assets/icons/messages.svg",
                selectedIcon: "assets/icons/messages_filled.svg",
                index: 2,
                homeScreenStore: widget.store,
              ),
              BottomBarIcon(
                iconData: "assets/icons/search.svg",
                selectedIcon: "assets/icons/search_filled.svg",
                index: 3,
                homeScreenStore: widget.store,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomBarIcon extends StatefulWidget {
  final int index;
  final String iconData;
  final String selectedIcon;
  final HomeScreenStore homeScreenStore;

  const BottomBarIcon({
    Key? key,
    required this.iconData,
    required this.selectedIcon,
    required this.index,
    required this.homeScreenStore,
  }) : super(key: key);
  @override
  _BottomBarIconState createState() => _BottomBarIconState();
}

class _BottomBarIconState extends State<BottomBarIcon> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 7,
      height: 56,
      color: Colors.transparent,
      child: Observer(
        builder: (context) {
          return InkResponse(
            onTap: () {
              widget.homeScreenStore.homeIndex = widget.index;
            },
            radius: 24,
            splashColor: Colors.white38,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: widget.index == widget.homeScreenStore.homeIndex
                      ? SvgPicture.asset(
                          widget.selectedIcon,
                          key: const Key("selected"),
                        )
                      : SvgPicture.asset(
                          widget.iconData,
                          key: const Key("unSelected"),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
