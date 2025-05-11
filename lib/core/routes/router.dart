import 'package:app/core/screens/chat_screen.dart';
import 'package:app/core/screens/machine_learning_demo.dart';
import 'package:app/core/screens/onbroading/add_photo_screen.dart';
import 'package:app/core/screens/profiles_screen_account.dart';
import 'package:app/core/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/onbroading/oops_screen.dart';
import '../screens/onbroading/number_screen.dart';
import '../screens/onbroading/verification_screen.dart';
import '../screens/onbroading/profile_screen.dart';
import '../screens/onbroading/welcome_screens.dart';
import '../screens/onbroading/ready_screen.dart';
// import '../screens/account_setting/account.dart';
import '../screens/singIn.dart';

import '../screens/profiles_user/profiles_user.dart';
import '../screens/profiles_user/information_user.dart';
import '../screens/profiles_user/likeScreen.dart';

import '../screens/profiles_user/searchScreen.dart';
import '../screens/onbroading/add_photo_screen.dart';

import '../screens/profiles_user/loadingScreen.dart';


final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>  SentimentAnalysisScreen(),
    ),
    GoRoute(
      path: '/RegisterScreen',
      builder: (context, state) =>SignUp(),
    ) ,
    GoRoute(
      path: '/oops',
      builder: (context, state) => const OopsScreen(),
    ),
    GoRoute(
      path: '/number',
      builder: (context, state) => const NumberScreen(),
    ),
    GoRoute(
      path: '/verification',
      builder: (context, state) => const VerificationScreen(),
    ),
    //trang danh cho thông tin tài khoản khi tạo tài khoản
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => ChatScreen(),
    ),
    // trang thông tin account
    GoRoute(
      path: '/user-profile',
      builder: (context, state) =>TinderProfilePage(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) =>WelcomeScreen(),
    ),
    GoRoute(
      path: '/ready',
      builder: (context, state) =>GetReadyScreen(),
    ),
    GoRoute(
      path: '/tinderUser',
      builder: (context, state) => TinderHomeScreen(),
    ),

    GoRoute(
      path: '/SignUp',
      builder: (context, state) => SignUp(),
    ),
    GoRoute(
      path: '/Information_user',
      builder: (context, state) =>UserProfileScreen(),
    ),
    GoRoute(
      path: '/likeScreen',
      builder: (context, state) =>LikesScreen(),
    ),
    GoRoute(
      path: '/DiscoveryScreen',
      builder: (context, state) =>DiscoveryScreen(),
    ),

    GoRoute(
      path: '/DiscoveryScreen',
      builder: (context, state) =>DiscoveryScreen(),
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) =>SearchingLoadingWidget(),
    )

  ],
);

class AppRouter {
  static GoRouter get router => _router;
}