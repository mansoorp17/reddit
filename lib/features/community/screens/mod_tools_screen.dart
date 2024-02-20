import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModeToolsScreen extends StatelessWidget {
  final String name;
  const ModeToolsScreen({super.key, required this.name});

  void navigateToModeTools(BuildContext context){
    Routemaster.of(context).push('/edit-community/$name');
  }

  void navigateToAddMods(BuildContext context){
    Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mod Tools"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.add_moderator),
            title: Text("Add Moderators"),
            onTap: () {
              navigateToAddMods(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit Community"),
            onTap: () {
              navigateToModeTools(context);
            },
          )
        ],
      ),
    );
  }
}
