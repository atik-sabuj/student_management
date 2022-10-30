import 'package:flutter/material.dart';
import 'package:student_management/pages/login_page.dart';
import 'package:student_management/pages/info_list_page.dart';
import 'package:student_management/pages/add_features.dart';
import 'package:student_management/pages/features_details.dart';
import 'package:student_management/providers/features_provider.dart';
import 'package:provider/provider.dart';

import 'pages/launcher_page.dart';
import 'providers/user_provider.dart';


void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FeaturesProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: LauncherPage.routeName,
      routes: {
        InfoListPage.routeName:(context)=>InfoListPage(),
        AddFeaturesPage.routeName:(context)=>AddFeaturesPage(),
        FeaturesDetailsPage.routeName:(context)=>FeaturesDetailsPage(),
        LoginPage.routeName:(context)=> const LoginPage(),
        LauncherPage.routeName:(context)=> const LauncherPage(),
      },
    );
  }
}


