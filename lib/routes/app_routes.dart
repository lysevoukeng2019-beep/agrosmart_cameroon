import 'package:flutter/material.dart';
import '../presentation/crop_database/crop_database.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/user_registration/user_registration.dart';
import '../presentation/community_forum/community_forum.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String cropDatabase = '/crop-database';
  static const String homeDashboard = '/home-dashboard';
  static const String userProfile = '/user-profile';
  static const String login = '/login-screen';
  static const String userRegistration = '/user-registration';
  static const String communityForum = '/community-forum';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    cropDatabase: (context) => const CropDatabase(),
    homeDashboard: (context) => const HomeDashboard(),
    userProfile: (context) => const UserProfile(),
    login: (context) => const LoginScreen(),
    userRegistration: (context) => const UserRegistration(),
    communityForum: (context) => const CommunityForum(),
    // TODO: Add your other routes here
  };
}
