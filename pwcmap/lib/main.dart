import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'screens/home.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      title: 'Pwc Map',
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
          duration: 700,
          splash: const Image(
            image: NetworkImage(
                'https://mma.prnewswire.com/media/449653/PWC_Logo.jpg?w=200'),
          ),
          nextScreen: const Pwcmap(),
          splashTransition: SplashTransition.fadeTransition,
          animationDuration: Duration(seconds: 1),
          pageTransitionType: PageTransitionType.bottomToTop,
          backgroundColor: Colors.white),
    ),
  );
}
