import 'package:flutter/material.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech2text/Pages/text.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const CURVE_HEIGHT = 150.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;

class Confirm extends StatefulWidget {
  final doctor_id;
  final message;
  final hospital_id;
  final doc_name;
  final dep;
  final id;
  final num;
  final spec;
  final gen;
  final name;
  final age;
  final phone;
  final gender;
  Confirm({this.message,
  this.doctor_id,
  this.hospital_id,
  this.doc_name,
  this.dep,
  this.id,
  this.num,
  this.spec,
  this.gen,
  this.name,
  this.age,
  this.phone,
  this.gender});
  @override
  ConfirmState createState() => new ConfirmState();
}

class ConfirmState extends State<Confirm> with SingleTickerProviderStateMixin {
  String isSet = "false";
  final Map<String, bool?> specific_items = {"null": false};
  final Map<String, bool?> general_items = {"null": false};
  List<dynamic> general=[];
  String symptom = "null";
  String selected_state= "General";

  TextEditingController newSymp = TextEditingController();
  void uploadFile() async {
    try {
      print(widget.message);
      var formData = FormData.fromMap({
        'text': widget.message        
      });
      var response = await Dio().post('https://vineet8588.pythonanywhere.com/symptom_extraction', data: formData);
      Map<String, dynamic> jsonMap = json.decode(response.toString());
      print(jsonMap);
      setState(() {
        for (var symp in jsonMap['symptoms']) {
          general_items[symp] = true;
        }
        print(general_items);
        general=jsonMap['symptoms'];
        print(general);
      });
      if (general_items.length != 0)
        isSet = "true";
    } catch (e) {
      print(e);
      isSet = "null";
    }
  }

  late PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;
  String selected = "Nothing";
  late AnimationController _controller;
  late Animation<Offset> _animation;

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
    uploadFile();
  }

  void _addItem(Map<String, bool?> category) {
    setState(() {
      if (newSymp.text != "") {
        category[newSymp.text.toUpperCase()] = true;
        general.add(newSymp.text.toUpperCase());
      }  
      print(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isSet != "false"
            ? Container(
                child: Stack(children: [
                  CurvedShape(),
                  Container(
                      margin:
                          EdgeInsets.only(top: CURVE_HEIGHT - AVATAR_DIAMETER),
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
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top:180.0,left: 250.0),
                    child: ElevatedButton(
                                child: Container(
              height: 40.0,
              width: 80.0,
              child: Padding(
                padding: const EdgeInsets.only(
                      left: 3.0, right: 3.0, top: 8.0, bottom: 8.0),
                child: Row(
                    children: [
                      Text("E.H.R"),
                      SizedBox(width: 15.0),
                      Icon(
                        FontAwesomeIcons.angleRight,
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
             onPressed: () => {
                            Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Speech2text(
                                    dep: widget.dep,
                                    doctor_id: widget.doctor_id,
                                    hospital_id: widget.hospital_id,
                                    doc_name: widget.doc_name,
                                    id: widget.id,
                                    num: widget.num,
                                    specific: specific_items,
                                    general: general_items,
                                    name:widget.name,
                                    age:widget.age,
                                    phone:widget.phone,
                                    gender:widget.gender,
                                  )
                                ))
                          },
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 250.0,left: 16.0,right: 16.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: 500.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               side: BorderSide(
              width: 10.0,
              color: Colors.blue,
            ),
                               shape: new RoundedRectangleBorder(
               borderRadius: new BorderRadius.circular(30.0),
               ),
                primary: selected_state=="General"?Colors.white:Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                             ),
                              child: Text("Extracted Symptoms",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: selected_state=="General"?Colors.black:Colors.white,
                    )),
                              onPressed: () => {
                                setState(() {
                                  selected_state = "General";
                                })
                              },
                            ), 
                          ],
                        )),
                  ),
                Padding(
              padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.40,
              left: MediaQuery.of(context).size.width*0.05,
              right: MediaQuery.of(context).size.width*0.05,
              bottom: MediaQuery.of(context).size.height*0.01),
              child: Container(
                height: MediaQuery.of(context).size.height*0.6,
                width: MediaQuery.of(context).size.height*0.48,
                decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(45.0),
                          bottomRight: Radius.circular(45.0),
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                color: Colors.white),
                child:(selected_state == "General")?
                _getGeneralList():_getSpecificList()
              ),
            ),  
                ]),
              )
            : Center(child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                width: 60.0,
                                height: 60.0,
                                child: Image(
                                  image: AssetImage('assets/load.gif'),
                                )),
                            Text(
                              "Extracting Symptoms",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontFamily: 'Montserrat'),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Please Be Patient",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontFamily: 'Montserrat'),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ))
              );
  }

  Widget _getGeneralList() {
    return SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 385.0,
            child: Scrollbar(
              isAlwaysShown: true,
                          child: ListView.builder(
                shrinkWrap: true,
                itemCount: general.length,
                itemBuilder: (BuildContext context, int i){
                  return Column(
                    children: [
                      Row(
                      children: [
                        Container(
                          width: 130.0,
                          child: Text(general[i],style: TextStyle(color: general_items[general[i]]==true?Colors.black:(specific_items[general[i]]==true?Colors.black:Colors.grey),fontSize: 15.0),),
                        ),
                        SizedBox(width:10.0),
                        ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               side: BorderSide(
                width: 1.0,
                color: Colors.grey
              ),
                               shape: new RoundedRectangleBorder(
                 borderRadius: new BorderRadius.circular(30.0),
                 ),
                  primary: general_items[general[i]]==true?Colors.green:Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                             ),
                              child: Text("General",
                        style: TextStyle(
                      fontSize: 15.0,
                      color: general_items[general[i]]==true?Colors.white:Colors.grey,
                        )),
                              onPressed: () => {
                                setState(() {
                                  general_items[general[i]]=true;
                                  specific_items[general[i]]=false;
                                })
                              },
                            ),
                            SizedBox(width:10.0),
                            ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               side: BorderSide(
                width: 1.0,
                color: Colors.grey
              ),
                               shape: new RoundedRectangleBorder(
                 borderRadius: new BorderRadius.circular(30.0),
                 ),
                  primary: specific_items[general[i]]==true?Colors.deepPurpleAccent:Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                             ),
                              child: Text("Specific",
                        style: TextStyle(
                      fontSize: 15.0,
                      color: specific_items[general[i]]==true?Colors.white:Colors.grey,
                        )),
                              onPressed: () => {
                                setState(() {
                                  general_items[general[i]]=false;
                                  specific_items[general[i]]=true;
                                })
                              },
                            ),
                            SizedBox(width:10.0),
                            IconButton(
                              icon: (specific_items[general[i]]==false&&general_items[general[i]]==false)?Icon(FontAwesomeIcons.trash):Icon(FontAwesomeIcons.trashAlt),
                              color:  (specific_items[general[i]]==false&&general_items[general[i]]==false)?Colors.black:Colors.grey,
                              onPressed: () => {
                                setState(() {
                                  general_items[general[i]]=false;
                                  specific_items[general[i]]=false;
                                })
                              },)
                      ],
                        ),
                      SizedBox(height: 20.0,)
                    ],
                  );
                }
                
              ),
            ),
          ),
          SizedBox(height:25.0),
          ElevatedButton(
            child: Container(
              height: 40.0,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                child: Text("+ Add More",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    )),
              ),
              decoration: new BoxDecoration(
                  color: Colors.blue,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0),
                    bottomLeft: const Radius.circular(40.0),
                    bottomRight: const Radius.circular(40.0),
                  )),
            ),
            onPressed: () => {
              newSymp.clear(),
              _displayTextInputDialog(context, general_items),
            },
          ),
        ],
      ),
    );
  }

  Widget _getSpecificList() {
    return SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 350.0,
            child: ListView(
              shrinkWrap: true,
              children: specific_items.keys.map((String key) {
                return new CheckboxListTile(
                  title: new Text(
                    key,
                    style: TextStyle(
                        color: specific_items[key] == true
                            ? Colors.black
                            : Colors.grey),
                  ),
                  value: specific_items[key],
                  onChanged: (bool? value) {
                    setState(() {
                      specific_items[key] = value;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            child: Container(
              height: 40.0,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                child: Text("+ Add More",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    )),
              ),
              decoration: new BoxDecoration(
                  color: Colors.blue,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0),
                    bottomLeft: const Radius.circular(40.0),
                    bottomRight: const Radius.circular(40.0),
                  )),
            ),
            onPressed: () => {
              newSymp.clear(),
              _displayTextInputDialog(context, specific_items),
            },
          ),
        ],
      ),
    );
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, Map<String, bool?> category) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add new Symptom'),
            actions: <Widget>[
              RawMaterialButton(
                onPressed: () {
                  _addItem(category);
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
            content: TextField(
              controller: newSymp,
              decoration: InputDecoration(hintText: "New Symptom"),
            ),
          );
        });
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
