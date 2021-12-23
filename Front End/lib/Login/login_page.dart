import 'package:flutter/material.dart';
import 'package:speech2text/Login/search.dart';
import 'package:speech2text/Login/sign_in.dart';
import 'package:speech2text/Login/sign_up.dart';
import 'package:speech2text/Utility/bubble_indicator_painter.dart';
import 'dart:math';
import '/Login/Doctor_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const CURVE_HEIGHT = 150.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;

class LoginPage extends StatefulWidget {
  final doctor_id;
  final hospital_id;
  final name;
  final dep;
  LoginPage({this.doctor_id,this.hospital_id,this.name,this.dep});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;
  String selected = "Nothing";
  late AnimationController _controller;
  late Animation<Offset> _animation;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  _signOut() async {
    await _firebaseAuth.signOut();
  }
  void changeName(String txt) {
    setState(() {
      selected = txt;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: const Offset(0.02, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(children: [
          _buildContent(),
          CurvedShape(),
          Container(
              margin: EdgeInsets.only(top: CURVE_HEIGHT - AVATAR_DIAMETER),
              width: double.infinity,
              height: AVATAR_DIAMETER,
              padding: EdgeInsets.all(8),
              child: Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                      image: ExactAssetImage('assets/MS_logo.png')),
                ),
              ))
        ]),
      ),
    ));
  }

  Widget _buildContent() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(173, 200, 255, 1),
              Colors.white,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 1.0),
            stops: <double>[0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 130.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              children: [
                SizedBox(width:10),
                   ElevatedButton(
                        child: Container(
                height: 30.0,
                width: 80.0,
                child: Center(
                  child: Row(
                    children: [
                      Text("Search"),
                      SizedBox(width: 15.0),
                      Icon(
                        FontAwesomeIcons.search,
                        color: Colors.white,
                        size: 16.0,
                        ),
                    ],
                  ),
                ),
                decoration: new BoxDecoration(
                        color: Colors.blue,
                        ),
              ),
               onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => searchPatients(
                            hospital_id: widget.hospital_id,
                          )),
                        );
               }),
               SizedBox(width:120),
                ElevatedButton(
                          child: Container(
                  height: 30.0,
                  width: 100.0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                            left: 3.0, right: 3.0, top: 8.0, bottom: 8.0),
                    child: Row(
                          children: [
                            Text("Log Out"),
                            SizedBox(width: 15.0),
                            Icon(
                              FontAwesomeIcons.arrowAltCircleRight,
                              color: Colors.white,
                              size: 16.0,
                              ),
                          ],
                    )
                  ),
                  decoration: new BoxDecoration(
                          color: Colors.blue,
                          ),
                ),
                 onPressed: () async {
                        await _signOut();
                        if (_firebaseAuth.currentUser == null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        }
                 }),
              ],
            ),
            SizedBox(height:20),
            _buildMenuBar(context),
            Expanded(
              flex: 2,
              child: PageView(
                controller: _pageController,
                physics: const ClampingScrollPhysics(),
                onPageChanged: (int i) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (i == 0) {
                    setState(() {
                      right = Colors.white;
                      left = Colors.black;
                    });
                  } else if (i == 1) {
                    setState(() {
                      right = Colors.black;
                      left = Colors.white;
                    });
                  }
                },
                children: <Widget>[
                  ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: SignUp(
                      doc_name: widget.name,
                      doctor_id: widget.doctor_id,
                      hospital_id: widget.hospital_id,
                      dep: widget.dep,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: SignIn(
                      doc_name: widget.name,
                      doctor_id: widget.doctor_id,
                      hospital_id: widget.hospital_id,
                      dep: widget.dep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: BubbleIndicatorPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignUpButtonPress,
                child: Text(
                  'New',
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignInButtonPress,
                child: Text(
                  'Existing',
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}

class CurvedShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: CURVE_HEIGHT,
      child: CustomPaint(
        painter: _MyPainter(),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = Colors.blue;

    Offset circleCenter = Offset(size.width / 2, size.height - AVATAR_RADIUS);

    Offset topLeft = Offset(0, 0);
    Offset bottomLeft = Offset(0, size.height * 0.25);
    Offset topRight = Offset(size.width, 0);
    Offset bottomRight = Offset(size.width, size.height * 0.5);

    Offset leftCurveControlPoint =
        Offset(circleCenter.dx * 0.5, size.height - AVATAR_RADIUS * 1.5);
    Offset rightCurveControlPoint =
        Offset(circleCenter.dx * 1.6, size.height - AVATAR_RADIUS);

    final arcStartAngle = 200 / 180 * pi;
    final avatarLeftPointX =
        circleCenter.dx + AVATAR_RADIUS * cos(arcStartAngle);
    final avatarLeftPointY =
        circleCenter.dy + AVATAR_RADIUS * sin(arcStartAngle);
    Offset avatarLeftPoint =
        Offset(avatarLeftPointX, avatarLeftPointY); // the left point of the arc

    final arcEndAngle = -5 / 180 * pi;
    final avatarRightPointX =
        circleCenter.dx + AVATAR_RADIUS * cos(arcEndAngle);
    final avatarRightPointY =
        circleCenter.dy + AVATAR_RADIUS * sin(arcEndAngle);
    Offset avatarRightPoint = Offset(
        avatarRightPointX, avatarRightPointY); // the right point of the arc

    Path path = Path()
      ..moveTo(topLeft.dx,
          topLeft.dy) // this move isn't required since the start point is (0,0)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..quadraticBezierTo(leftCurveControlPoint.dx, leftCurveControlPoint.dy,
          avatarLeftPoint.dx, avatarLeftPoint.dy)
      ..arcToPoint(avatarRightPoint, radius: Radius.circular(AVATAR_RADIUS))
      ..quadraticBezierTo(rightCurveControlPoint.dx, rightCurveControlPoint.dy,
          bottomRight.dx, bottomRight.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
