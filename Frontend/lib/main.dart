import 'package:flutter/material.dart';
import 'package:main/splash_screnn.dart';
import 'package:main/view/home/welcome.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: SplashScrenn(),
      ),
    ));
  }
}
