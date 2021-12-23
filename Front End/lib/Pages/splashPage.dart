import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech2text/Login/Doctor_login.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void initState() {
    super.initState();
    playAnimation();
  }

  Future<void> playAnimation() async {
    Future.delayed(const Duration(milliseconds: 4000), () {
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          SizedBox(height: height * 0.38),
          FadeIn(
            child: Text(
              "Medi",
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 60,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                  color: Colors.blue),
            ),
            duration: Duration(seconds: 2),
          ),
          FadeIn(
            child: Text(
              "Scribe",
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 60,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                  color: Colors.blue),
            ),
            duration: Duration(seconds: 2),
          ),
          SizedBox(height: height * 0.37),
          SpinKitWave(
            color: Colors.blue,
            size: 50.0,
            //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
          )
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/doc.gif'),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
