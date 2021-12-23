import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'list.dart';
import 'view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final doctor_id;
  final hospital_id;
  final doc_name;
  final dep;
  final String name;
  final String age;
  final String phone;
  final String gender;
  final String id;
  HomePage({required this.name, required this.age, required this.phone, required this.gender,required this.id,this.doctor_id,this.hospital_id,this.doc_name,this.dep});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Directory? appDir;
  late List<String>? records;
  String isTapped = "NO";

  @override
  void initState() {
    super.initState();
    records = [];
    getExternalStorageDirectory().then((value) {
      appDir = value!;
      Directory appDirec = Directory("${appDir!.path}/Audiorecords/${widget.id}_${widget.name}");
      appDir = appDirec;
      appDir!.list().listen((onData) {
        records!.add(onData.path);
      }).onDone(() {
        records = records!.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    appDir = null;
    records = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          isTapped == "NO"
              ? Column(
                  children: [
                    Container(
                      height: 150.0,
                      width: 400.0,
                      decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius: new BorderRadius.only(
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Center(
                          child: Text(
                            "Session Area",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Montserrat',
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          isTapped = "YES";
                        });
                      },
                      elevation: 5.0,
                      fillColor: Colors.blue.shade400,
                      child: Column(
                        children: [
                          Icon(
                            FontAwesomeIcons.microphone,
                            color: Colors.white,
                            size: 50.0,
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Start New Session',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: 'WorkSansBold'),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(70.0),
                      shape: CircleBorder(),
                    ),
                  ],
                )
              : Recorder(
                dep: widget.dep,
                doctor_id: widget.doctor_id,
                hospital_id: widget.hospital_id,
                doc_name: widget.doc_name,
                  save: _onFinish,
                  name: widget.name,
                  phone: widget.phone,
                  gender: widget.gender,
                  age: widget.age,
                  id: widget.id,
                ),
          Expanded(
            flex: 2,
            child: Records(
              dep: widget.dep,
              doctor_id: widget.doctor_id,
              hospital_id: widget.hospital_id,
              doc_name: widget.doc_name,
              records: records!,
              id: widget.id,
              name: widget.name,
              phone: widget.phone,
              gender: widget.gender,
              age: widget.age,
            ),
          ),
        ],
      ),
    );
  }

  _onFinish() {
    records!.clear();
    print(records!.length.toString());
    appDir!.list().listen((onData) {
      records!.add(onData.path);
    }).onDone(() {
      records!.sort();
      records = records!.reversed.toList();
      setState(() {});
    });
  }
}
