//2 types of router
//logged out
//logged in

import 'package:flutter/material.dart';
import 'package:reddit/features/auth/screens/login_screen.dart';
import 'package:reddit/features/community/screens/add_mods_screen.dart';
import 'package:reddit/features/community/screens/community_screen.dart';
import 'package:reddit/features/community/screens/create_community_screen.dart';
import 'package:reddit/features/community/screens/edit_community_screen.dart';
import 'package:reddit/features/community/screens/mod_tools_screen.dart';
import 'package:reddit/features/home/screens/home_Screen.dart';
import 'package:reddit/features/post/screens/add_post_type_screen.dart';
import 'package:reddit/features/post/screens/comment_screen.dart';
import 'package:reddit/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute=RouteMap(routes: {
  '/':(_)=> const MaterialPage(child: LoginScreen()),
});

final loggeedInRoute=RouteMap(routes: {

  '/':(_)=> const MaterialPage(child: HomeScreen()),
  '/create-community':(_)=> const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name':(route)=> MaterialPage(child: CommunityScreen(name: route.pathParameters['name']!,)),
  '/mod-tools/:name':(routeData)=> MaterialPage(child: ModeToolsScreen(name:routeData.pathParameters['name']!,)),
  '/edit-community/:name':(routeData)=> MaterialPage(child: EditCommunityScreen(name:routeData.pathParameters['name']!,)),
  '/add-mods/:name':(routeData)=> MaterialPage(child: AddModsScreen(name:routeData.pathParameters['name']!,)),
  '/u/:uid':(routeData) => MaterialPage(child: UserProfileScreen(uid: routeData.pathParameters['uid']!),),
  '/edit-profile/:uid':(routeData) => MaterialPage(child: EditProfileScreen(uid: routeData.pathParameters['uid']!),),
  '/add-post/:type':(routeData) => MaterialPage(child: AddPostTypeScreen(type: routeData.pathParameters['type']!,),),
  '/post/:postId/comments':(routeData) => MaterialPage(child: CommentScreen(postId: routeData.pathParameters['postId']!,),),
});