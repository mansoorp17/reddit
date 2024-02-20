import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_defs.dart';
import 'package:reddit/models/community_model.dart';

import '../../../models/post_model.dart';

final communityRepositoryProvider=Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository{
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore}) : _firestore=firestore;

  FutureVoid createCommunity(Community community) async{
    try{
      var communityDoc=await _communinities.doc(community.name).get();
      if(communityDoc.exists){
        throw 'Community with the same name already exists!';
      }
      return right(_communinities.doc(community.name).set(community.toJson()));
    }
    on FirebaseException catch(e){
      throw e.message!;
    }
    catch (e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName, String userId)async {
    try{
      return right(_communinities.doc(communityName).update({
        'members':FieldValue.arrayUnion([userId]),
      }));
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId)async {
    try{
      return right(_communinities.doc(communityName).update({
        'members':FieldValue.arrayRemove([userId]),
      }));
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid){
    return _communinities.where('members', arrayContains: uid).snapshots().map((event) {
      List <Community> communities=[];
      for(var doc in event.docs){
        communities.add(Community.fromJson(doc.data() as Map<String,dynamic>));
    }
      return communities;
    });
}

  Stream<Community> getCommunityByName(String name){
    return _communinities.doc(name).snapshots().map((event) => Community.fromJson(event.data() as Map<String,dynamic>));
  }

  FutureVoid editCommunity(Community community) async{
    try{
      return right(_communinities.doc(community.name).update(community.toJson()));
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query){
    return _communinities
        .where(
        'name',
        isGreaterThanOrEqualTo:query.isEmpty ? 0: query,
        isLessThan: query.isEmpty ? null : query.substring(0, query.length-1) +
            String.fromCharCode(
                query.codeUnitAt(query.length-1) + 1
            ),
        )
        .snapshots().map((event) {
          List<Community> communities=[];
          for(var community in event.docs){
            communities.add(Community.fromJson(community.data() as Map<String,dynamic>));
          }
          return communities;
    });
  }

  FutureVoid addMods(String communityName, List<String> uids) async{
    try{
      return right(_communinities.doc(communityName).update({
        'mods':uids,
      }));
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getCommunityPosts(String name){
    return _posts.where('communityName', isEqualTo: name).orderBy('createdAt', descending: true).snapshots().map(
          (event) => event.docs
          .map((e) => Post.fromJson(
        e.data() as Map<String, dynamic>,
      ),
      ).toList(),
    );
  }

  CollectionReference get _communinities=>_firestore.collection(FirebaseConstants.communitiesCollection);
  CollectionReference get _posts=>_firestore.collection(FirebaseConstants.postsCollection);
}