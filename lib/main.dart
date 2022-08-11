import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/screen_landing.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/widget/loader.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/router.dart';
import 'package:whatsapp_clone/widgets/error.dart';

import 'features/auth/controller/auth_controller.dart';
import 'mobile_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NizeChat',
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: backgroundColor,
            appBarTheme: const AppBarTheme(color: appBarColor)),
        // home: ResponsiveLayout(
        //   mobileScreenLayout: MobileLayoutScreen(),
        //   // webScreenLayout: WebLayoutScreen(),
        // ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreeen(
                error: err.toString(),
              );
            },
            loading: () => const Loader()));
  }
}
