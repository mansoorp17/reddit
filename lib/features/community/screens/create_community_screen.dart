import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';

import '../../../main.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController=TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity(){
    ref.read(communityControllerProvider.notifier).createCommunity(
        communityNameController.text.trim(),
        context,
    );
  }
  @override
  Widget build(BuildContext context) {
    final isLoading=ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create a community"),
        centerTitle: true,
      ),
      body: isLoading
      ?const Loader()
      :Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
                child: Text("Community name")
            ),
            SizedBox(height: height*0.012,),
            TextField(
              controller: communityNameController,
              decoration: InputDecoration(
                hintText: 'Community_name',
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(height*0.0216),
              ),
              maxLength: 21,
            ),
            SizedBox(height: height*0.036,),
            ElevatedButton(
                onPressed: createCommunity,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, height*0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(height*0.024),
                  )
                ),
                child: Text("Create community",style: TextStyle(
                  fontSize: height*0.0204,
                ),)
            ),
          ],
        ),
      ),
    );
  }
}
