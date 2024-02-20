import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/enums/enums.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';
import '../../../models/community_model.dart';
import '../../../models/post_model.dart';
import '../../community/repository/community_repository.dart';
import '../repository/user_profile_repository.dart';

final userProfileControllerProvider = NotifierProvider<UserProfileController,bool>(

    ()  {
          return UserProfileController();
        },
);

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends Notifier<bool>{

  UserProfileRepository get _userProfileRepository=>ref.read(userProfileRepositoryProvider);
  StorageRepository get _storageRepository=>ref.read(storageRepositoryProvider);


  void editProfile({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required String name,
  })async{
    state=true;
    UserModel user=ref.read(userProvider)!;

    if(profileFile!=null){
      final res=await _storageRepository.storeFile(
          path: 'users/profile',
          file: profileFile,
          id: user.uid
      );
      res.fold(
            (l) => showSnackBar(context,l.message),
            (r) => user=user.copyWith(profilePic: r),
      );
    }

    if(bannerFile!=null){
      final res=await _storageRepository.storeFile(
          path: 'users/banner',
          id: user.uid,
          file: bannerFile
      );
      res.fold(
            (l) => showSnackBar(context,l.message),
            (r) => user=user.copyWith(banner: r),
      );
    }

    user=user.copyWith(name: name);
    final res=await _userProfileRepository.editProfile(user);
    state=false;
    res.fold(
          (l) => showSnackBar(context,l.message),
          (r) {
            ref.read(userProvider.notifier).update((state) => user);
            Routemaster.of(context).pop();
          },
    );
  }

  Stream<List<Post>> getUserPosts(String uid){
    return _userProfileRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma) async{
    UserModel user = ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);

    final res = await _userProfileRepository.updateUserKarma(user);
    res.fold((l) => null, (r) => ref.read(userProvider.notifier).update((state) => user));
  }

  @override
  build() {
    return false;
  }
}
