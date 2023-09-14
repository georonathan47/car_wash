import 'package:carwash/constants.dart';
import 'package:carwash/screen/Landing.dart';
import 'package:carwash/screen/Layout.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController? _controller;
  bool isLogoExpanded = true; // Start with the logo expanded

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final String? token = await ShPref.getAuthToken();
      if (token!='') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CWLayout()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingPage()));
      }
    });


    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller!.forward();
      }
    });
    _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Your other splash screen content here
      body: Center(
        child: AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) {
            // Use a Tween to smoothly interpolate the logo size
            double size = Tween<double>(
              begin: Const.wi(context) /1.5,
              end: Const.wi(context) /4,
            ).animate(_controller!).value;

            return Image.asset(
              Const.logo,
              width: size,
              height: size,
            );
          },
        ),
      ),
    );
  }
}
