// ignore_for_file: no_duplicate_case_values

import 'package:flutter/material.dart';
import 'package:friend_mobile/ui/buy_premium/premium_payment_screen.dart';
import 'package:friend_mobile/ui/buy_premium/premium_upgrade_screen.dart';
import 'package:friend_mobile/ui/calling/calling_screen.dart';
import 'package:friend_mobile/ui/community_page/community_page_screen.dart';
import 'package:friend_mobile/ui/community_wall/wall_community_screen.dart';
import 'package:friend_mobile/ui/confessions/confessions_screen.dart';
import 'package:friend_mobile/ui/home/home_screen.dart';
import 'package:friend_mobile/ui/home/home_store.dart';
import 'package:friend_mobile/ui/login/login_screen.dart';
import 'package:friend_mobile/ui/member_near_you/member_near_screen.dart';
import 'package:friend_mobile/ui/members_list/members_list_screen.dart';
import 'package:friend_mobile/ui/share_post/share_post_screen.dart';
import 'package:friend_mobile/ui/share_story/share_story_screen.dart';
import 'package:friend_mobile/ui/signup/hobbies_select_screen.dart';
import 'package:friend_mobile/ui/signup/profile_pic_screen.dart';
import 'package:friend_mobile/ui/signup/signup_screen.dart';
import 'package:friend_mobile/ui/splash_screen/splash_screen.dart';
import 'package:friend_mobile/ui/user_profile/other_profile_screen.dart';

MaterialPageRoute generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.route:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
    case LoginScreen.route:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case SignupScreen.route:
      return MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      );
    // case ProfilePicSelectScreen.route:
    //   return MaterialPageRoute(
    //     builder: (context) => const ProfilePicSelectScreen(),
    //   );
    // case HobbiesSelectScreen.route:
    //   return MaterialPageRoute(
    //     builder: (context) => const HobbiesSelectScreen(),
    //   );
    case HomeScreen.route:
      return MaterialPageRoute(
        builder: (context) => HomeScreen(
          homeScreenStore: HomeScreenStore(),
        ),
      );
    case ConfessionScreen.route:
      return MaterialPageRoute(
        builder: (context) => const ConfessionScreen(),
      );
    case PremiumUpgradeScreen.route:
      return MaterialPageRoute(
        builder: (context) => const PremiumUpgradeScreen(),
      );
    // case PremiumPaymentScreen.route:
    //   return MaterialPageRoute(
    //     builder: (context) => const PremiumPaymentScreen(),
    //   );
    case CallingScreen.route:
      return MaterialPageRoute(
        builder: (context) => const CallingScreen(),
      );
    case SharePostScreen.route:
      return MaterialPageRoute(
        builder: (context) => const SharePostScreen(),
      );
    case ShareStoryScreen.route:
      return MaterialPageRoute(
        builder: (context) => const ShareStoryScreen(),
      );
    case OtherProfileScreen.route:
      return MaterialPageRoute(
        builder: (context) => const OtherProfileScreen(),
      );
    // case CommunityPageScreen.route:
    //   return MaterialPageRoute(
    //     builder: (context) => const CommunityPageScreen(),
    //   );
    // case CommunityWallScreen.route:
    //   return MaterialPageRoute(
    //     builder: (context) => const CommunityWallScreen(),
    //   );
    // case MemberListScreen.route:
    //   return MaterialPageRoute(
    //     builder: (context) => const MemberListScreen(),
    //   );
    // case MembersNearScreen.route:
    //   return MaterialPageRoute(
    //     builder: (context) => const MembersNearScre  en(),
    //   );
    default:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
  }
}
