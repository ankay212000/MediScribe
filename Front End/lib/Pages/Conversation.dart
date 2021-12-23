import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech2text/Pages/confirm_form.dart';

class conversation extends StatefulWidget {
  final language;
  final doctor_id;
  final hospital_id;
  final doc_name;
  final id;
  final dep;
  final num;
  final filename;
  final name;
  final age;
  final phone;
  final gender;
  conversation({this.language,this.doctor_id,this.hospital_id,this.doc_name,this.dep,this.id,this.num,this.filename, this.name, this.age, this.phone, this.gender});
  @override
  _conversationState createState() => _conversationState();
}

class _conversationState extends State<conversation> {
  String isSet = "false";
  final Map<String, bool?> specific_items = {"null": false};
  final Map<String, bool?> general_items = {"null": false};
  List<String> specific=[], general=[];
  String convo="null";
  String symptom = "null";
  
  bool _isEditingText = false;
  late TextEditingController _editingController;

  TextEditingController newSymp = TextEditingController();
  void uploadFile() async {
    try {
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(widget.filename,
            filename: widget.filename.split("/").last),        
      });
      var response = await Dio().post(
          'https://vineet8588.pythonanywhere.com/file-upload',
          data: formData);
      Map<String, dynamic> jsonMap = json.decode(response.toString());
      print(jsonMap);
      setState(() {
        convo=jsonMap['converted_text'];
        _editingController = TextEditingController(text: convo);
        /*for (var symp in jsonMap['specific']) {
          specific_items[symp] = true;
          specific.add(symp);
        }*/
        /*for (var symp in jsonMap['symptoms']) {
          general_items[symp] = true;
          general.add(symp);
        }*/
      });
      if (convo.length!=0)
        isSet = "true";
    } catch (e) {
      print(e);
      isSet = "null";
    }
  }


  @override
  void initState() {
    super.initState();
    uploadFile();
  }
  
  @override
  void dispose() {
  _editingController.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: isSet != "false"?Container(
            height: height,
            width: width,
            child:SingleChildScrollView(
                                  child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top:50.0,left:8.0),
                        child: Row(
                          children: [
                            Text("Patient Name:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            SizedBox(width: 10.0),
                            Text(widget.name)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Row(
                          children: [
                            Text("Phone Number:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            SizedBox(width: 10.0),
                            Text(widget.phone)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Row(
                          children: [
                            Text("Gender:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            SizedBox(width: 10.0),
                            Text(widget.gender)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Row(
                          children: [
                            Text("Date of Birth:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            SizedBox(width: 10.0),
                            Text(widget.age.toString().split(' ')[0])
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:100.0,right: 100.0),
                        child: Row(
                          children: [
                            ElevatedButton(
                      child: Container(
              height: 40.0,
              width: 140.0,
              child: Padding(
                padding: const EdgeInsets.only(
                        left: 3.0, right: 3.0, top: 8.0, bottom: 8.0),
                child: Row(
                      children: [
                        Text("Extract Symptom"),
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
             onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Confirm(
                                  message: _editingController.text,
                                  dep: widget.dep,
                                  doctor_id: widget.doctor_id,
                                  hospital_id: widget.hospital_id,
                                  doc_name: widget.doc_name,
                                  spec: specific,
                                  gen: general,
                                  id: widget.id,
                                  num: widget.num,
                                  name: widget.name,
                                      phone: widget.phone,
                                      age: widget.age,
                                      gender: widget.gender,)))
                        ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text("Conversation",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40.0)),
                      SizedBox(height: 10.0),
                      Container(
                        child:SingleChildScrollView(
                                                child: Column(children: [
                              Container(
                            width: 250.0,
                            height: 3.0,
                            color: Colors.grey[400],
                          ),
                      SizedBox(height: 20.0),
                      convo!="null"?
                      Container(
                        height: convo.length*2,
                        decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0),
                        bottomLeft: const Radius.circular(40.0),
                        bottomRight: const Radius.circular(40.0),
                        )),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: _editTitleTextField(),
                        ),)
                      :Container(
                          height: 30.0,
                          child: Text("No Text Extracted")),
                          ],),
                        )
                        ,)  
                    ]),
                )
                ):Center(child:Column(
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
                              "Converting Audio to Text...",
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
  
  Widget _editTitleTextField() {
  if (_isEditingText)
    return Center(
      child: TextField(
        onSubmitted: (newValue){
          setState(() {
            convo = newValue;
            _isEditingText =false;
          });
        },
        autofocus: true,
        controller: _editingController,
      ),
    );
  return InkWell(
    onTap: () {
      setState(() {
        _isEditingText = true;
      });
    },
    child: Text(
  convo,
  style: TextStyle(
    color: Colors.black,
    fontSize: 18.0,
  ),
 ));
}
}