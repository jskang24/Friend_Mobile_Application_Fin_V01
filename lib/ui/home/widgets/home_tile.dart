import 'package:flutter/material.dart';
import 'package:friend_mobile/ui/community_page/community_page_screen.dart';

class HomeTile extends StatelessWidget {
  const HomeTile({
    Key? key,
    required this.label,
    required this.count1,
    required this.count2,
    required this.imageURL,
    required this.onTap,
  }) : super(key: key);
  final String label, count1, count2, imageURL;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CommunityPageScreen(name: label.toString())));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
        height: 78,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.12),
              offset: const Offset(2, 5),
              blurRadius: 10,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "$count1 members",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "$count2 posts",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff8E12AA),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
