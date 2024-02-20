import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/models/community_model.dart';

import '../../../core/constants/constants.dart';
import '../../../main.dart';
import '../../../theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
File? bannerFile;
File? profileFile;

  Future<void> selectBannerImage() async {
    final res=await pickImage();
    if(res!=null) {
        setState(() {
          bannerFile=File(res.files.first.path!);
        });
      }
  }
  Future<void> selectProfileImage() async {
    final res=await pickImage();
    if(res!=null) {
        setState(() {
          profileFile=File(res.files.first.path!);
        });
      }
  }

  void save(Community community){
    ref.read(communityControllerProvider.notifier).editCommunity(
        profileFile: profileFile,
        bannerFile: bannerFile,
        context: context,
        community: community,
    );
  }
  @override
  Widget build(BuildContext context) {
    final isLoading=ref.watch(communityControllerProvider);
    final currentTheme=ref.read(themeNotifierProvider);

    return ref.watch(getCommunityByNameProvider(widget.name))
        .when(
        data: (community) => Scaffold(
          backgroundColor: currentTheme.backgroundColor,
          appBar: AppBar(
            title: Text("Edit Community"),
            actions: [
              TextButton(onPressed:() => save(community),
                  child: Text("Save"))
            ],
          ),
          body: isLoading ?
          const Loader()
              : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: DottedBorder(
                          radius: Radius.circular(height*0.012),
                          borderType: BorderType.RRect,
                          dashPattern: const [10,4],
                          strokeCap: StrokeCap.round,
                          color: currentTheme.textTheme.bodyText2!.color!,
                          child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(width*0.012),
                              ),
                              child: bannerFile!=null
                                  ? Image.file(bannerFile!)
                                  : community.banner.isEmpty || community.banner == Constants.bannerDefault
                                  ? Center(child: Icon(Icons.camera_alt_outlined, size: 40,))
                                  : Image.network(community.banner)
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: selectProfileImage,
                          child: profileFile!=null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(profileFile!),
                                  radius: 32,
                              )
                              :CircleAvatar(
                                  backgroundImage: NetworkImage(community.avatar),
                                  radius: 32,
                                ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => Loader(),
    );
  }
}
