import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/auth/screens/login_screen.dart';
import 'package:reddit/models/user_model.dart';
import 'package:reddit/router.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import 'firebase_options.dart';

Future <void> main()
async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      const ProviderScope(
          child: MyApp()
      )
  );
}

var height;
var width;

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  Future<void> getData(WidgetRef ref,User data) async {
    userModel=await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    width= MediaQuery.of(context).size.width;
    height= MediaQuery.of(context).size.height;

    return ref.watch(authStateChangeProvider)
        .when(
      data: (data) => MaterialApp.router(
        title: 'Reddit',
        theme: ref.watch(themeNotifierProvider),
        debugShowCheckedModeBanner: false,
        routerDelegate: RoutemasterDelegate(
          routesBuilder: (context) {
            if(data!=null){
              getData(ref, data);
              if(userModel!=null)
                {
                  return loggeedInRoute;
                }
            }
            return loggedOutRoute;
          },),
        routeInformationParser: RoutemasterParser(),
      ),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => Loader(),
    );
  }
}

