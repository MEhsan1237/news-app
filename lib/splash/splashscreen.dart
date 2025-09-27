import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/main.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(),));
    });
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height*1;
    final width = MediaQuery.of(context).size.width*1;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: height*.1,),
          Image.asset("assets/images/splash.one.png",
            fit: BoxFit.cover,
            height: height*.6,
            width: width*.9,),
          SizedBox(height:height*.04),
          Center(
            child: Text("Top Headlines",style:GoogleFonts.anton(
                color: Colors.black,
                fontSize: 12,
                letterSpacing: 1,
                fontWeight: FontWeight.w500
            ) ),
          ),
          SizedBox(height: height*.02,),
          SpinKitChasingDots(
            color: Colors.deepPurple,
            size: 24,


          )
        ],
      ),
    );
  }
}


