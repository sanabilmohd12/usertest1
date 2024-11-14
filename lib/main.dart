import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testcase1/view/auth/LoginPage.dart';
import 'package:testcase1/view/auth/OTPpage.dart';
import 'package:testcase1/view/home/homepage.dart';
import 'package:testcase1/viewmodel/mainprovider.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCxp5c_Xoc4DX6p-Dl6C4TCmgbM7cZswkU",
        appId: "1:481573325822:android:a0d2207995f3ba982e8eaf",
        messagingSenderId: "481573325822",
        projectId: "testtask1-c3791",
        storageBucket: "testtask1-c3791.firebasestorage.app"),
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainProvider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage(),
      ),
    );
  }
}

