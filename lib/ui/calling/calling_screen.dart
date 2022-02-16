import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({Key? key}) : super(key: key);
  static const String route = "Calling";
  @override
  _CallingScreenState createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  bool _videoOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: 24,
        title: !_videoOn
            ? const Text("Call")
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Samuel Jackson",
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "00:03:45",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _videoOn
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset("assets/images/ongoing_videocall.png"),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/ongoing_call.png"),
                        const SizedBox(height: 24),
                        const Text(
                          "Samuel Jackson",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "00:03:45",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 30,
                left: 32,
                right: 32,
              ),
              child: Material(
                color: const Color(0xff303030),
                borderRadius: BorderRadius.circular(60),
                child: SizedBox(
                  height: 74,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CallingIconButton(
                        selectedIcon: "assets/icons/video_on.svg",
                        icon: "assets/icons/video_off.svg",
                        onTap: () {
                          setState(() {
                            _videoOn = !_videoOn;
                          });
                        },
                      ),
                      CallingIconButton(
                          icon: "assets/icons/mic_on.svg",
                          selectedIcon: "assets/icons/mic_off.svg",
                          onTap: () {}),
                      CallingIconButton(
                          icon: "assets/icons/headset.svg",
                          selectedIcon: "assets/icons/headset.svg",
                          onTap: () {}),
                      CallingIconButton(
                          icon: "assets/icons/end_call.svg",
                          selectedIcon: "assets/icons/end_call.svg",
                          onTap: () {}),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CallingIconButton extends StatefulWidget {
  const CallingIconButton({
    Key? key,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
  }) : super(key: key);
  final String icon, selectedIcon;
  final VoidCallback onTap;
  @override
  _CallingIconButtonState createState() => _CallingIconButtonState();
}

class _CallingIconButtonState extends State<CallingIconButton> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 7,
        height: 56,
        color: Colors.transparent,
        child: InkResponse(
          onTap: () {
            setState(() {
              _selected = !_selected;
            });
            widget.onTap.call();
          },
          radius: 24,
          splashColor: Colors.white38,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _selected
                    ? SvgPicture.asset(
                        widget.selectedIcon,
                        key: const Key("selected"),
                      )
                    : SvgPicture.asset(
                        widget.icon,
                        key: const Key("unSelected"),
                      ),
              ),
            ],
          ),
        ));
  }
}
