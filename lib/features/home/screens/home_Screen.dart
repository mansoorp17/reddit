import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/home/delegates/search_community_delegate.dart';
import 'package:reddit/features/home/drawers/community_list_drawer.dart';
import 'package:reddit/features/home/drawers/profile_drawer.dart';

import '../../../theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}
  class _HomeScreenState extends ConsumerState<HomeScreen>{
  int _page=0;

  void displayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page){
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user=ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme=ref.read(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
                onPressed: () => displayDrawer(context),
                icon: Icon(Icons.menu)
            );
          }
        ),
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchCommunityDelegate(ref));
              },
              icon: Icon(Icons.search)
          ),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  displayEndDrawer(context);
                },
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
              );
            }
          )
        ],
      ),
      body: Constants.tabWidgets[_page],
      drawer: const   CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: currentTheme.iconTheme.color,
          backgroundColor: currentTheme.backgroundColor,
          items:  [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
              label: ''
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: ''
            ),
          ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
    );
  }
}
