import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lady_rakshak/Utils/flutter_bg_service.dart';
import 'package:lady_rakshak/child/bottom_page.dart';
import 'package:lady_rakshak/db/shared_pref.dart';
import 'package:lady_rakshak/login_screen.dart';
import 'package:lady_rakshak/parent/parent_home_screen.dart';

import 'Utils/constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MysharedPref.init();
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.firaSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: MysharedPref.getUserType(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is loading, show a progress indicator
              return progressIndicator(context);
            } else if (snapshot.hasError) {
              // If there's an error, handle it accordingly
              return Text('Error: ${snapshot.error}');
            } else {
              // Check if the snapshot data is null
              if (snapshot.data == null) {
                // Handle the case where snapshot data is null
                return Text('User type not available');
              } else {
                // Check the user type and navigate to the appropriate screen
                final userType = snapshot.data!;
                if (userType == "") {
                  return LoginScreen();
                } else if (userType == "child") {
                  return BottomPage();
                } else if (userType == "parent") {
                  return ParentHomeScreen();
                } else {
                  // If the user type is unknown, handle it accordingly
                  return Text('Unknown user type');
                }
              }
            }
          }),
    );
  }
}
