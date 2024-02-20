import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/sign_in_button.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';

import '../../../core/constants/constants.dart';
import '../../../main.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInAsGuest(WidgetRef ref, BuildContext context){
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isLoading=ref.watch(authControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(Constants.logoPath,
          height: height*0.048,
          ),
          centerTitle: true,
          actions: [
              TextButton(onPressed: () =>signInAsGuest(ref,context),
                  child: Text("Skip",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),)
              )
          ],
        ),
      body: isLoading
          ? Loader()
          :Column(
        children: [
          SizedBox(height: height*0.036,),
          Text("Dive into anything",style: TextStyle(
            fontSize: width*0.05808,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5
          ),),
          SizedBox(height: height*0.036,),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset(Constants.loginEmotePath,
            height: height*0.48,),
          ),
          SizedBox(height: height*0.024,),
          SignInButton(),
        ],
      ),
    );
  }
}
