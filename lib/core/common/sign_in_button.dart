import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/theme/pallete.dart';

import '../../main.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  void signInWithGoogle(BuildContext context,WidgetRef ref){
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding:  EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(context,ref),
          icon: Image.asset(Constants.googlePath,
          width: width*0.0847,),
          label: Text("Continue with Google",style: TextStyle(
            fontSize: width*0.04356,
          ),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: Size(double.infinity, height*0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width*0.0484)
          )
        ),
      ),
    );
  }
}
