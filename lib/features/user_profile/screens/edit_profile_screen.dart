import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/user_profile/controller/user_profile_controller.dart';
import 'package:riverpod/riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../main.dart';
import '../../../theme/pallete.dart';
import '../../community/controller/community_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override

  void initState() {
      super.initState();
      nameController=TextEditingController(text: ref.read(userProvider)!.name);
  }

  void dispose() {
    super.dispose();
    nameController.dispose();
  }

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

  void save(){
    ref.read(userProfileControllerProvider.notifier)
        .editProfile(
        profileFile: profileFile,
        bannerFile: bannerFile,
        context: context,
        name: nameController.text.trim()
    );
  }
  Widget build(BuildContext context) {
    final isLoading=ref.read(userProfileControllerProvider);
    final currentTheme=ref.read(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid))
        .when(
        data: (user) => Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          TextButton(onPressed:() {
            save();
          },
              child: Text("Save"))
        ],
      ),
      body: isLoading
          ? const Loader()
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
                              : user.banner.isEmpty || user.banner == Constants.bannerDefault
                              ? Center(child: Icon(Icons.camera_alt_outlined, size: 40,))
                              : Image.network(user.banner)
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
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 32,
                      ),
                    ),
                  )
                ],
              ),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Name',
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(18),
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
