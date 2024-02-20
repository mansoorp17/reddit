import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/features/post/controller/post_controller.dart';
import 'package:reddit/features/post/widget/comment_card.dart';

import '../../../models/post_model.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState createState() => _CommentScreenState();
}


class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post){
    ref.read(postControllerProvider.notifier)
        .addComment(
        context: context,
        text: commentController.text.trim(),
        post: post
    );
    setState(() {
      commentController.text = '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId))
          .when(
          data: (data) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  PostCard(post: data),
                  TextField(
                    onSubmitted: (value) => addComment(data),
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: "What are your thoughts?",
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  ref.watch(getPostCommentsProvider(widget.postId))
                      .when(
                      data: (data) {
                        return ListView.builder(
                          shrinkWrap: true,
                            itemCount : data.length,
                            itemBuilder: (context, index) {
                              final comment = data[index];
                              return CommentCard(comment: comment);
                            },
                        );
                      },
                      error: (error, stackTrace) {
                        // print(error.toString());
                        return ErrorText(error: error.toString());
                      },
                      loading: () => Loader(),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(
              error: error.toString()
          ),
          loading: () => Loader(),
      ),
    );
  }
}
