import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class Speech2text extends StatefulWidget {
  final doctor_id;
  final hospital_id;
  final doc_name;
  final dep;
  final num;
  final id;
  final specific;
  final general;
  final name;
  final age;
  final phone;
  final gender;
  Speech2text({
    this.doctor_id,
    this.hospital_id,
    this.doc_name,
    this.id,
    this.dep,
    this.num,
    this.specific,
    this.general,
    this.name,
    this.age,
    this.phone,
    this.gender
  });

  @override
  _Speech2textState createState() => _Speech2textState();
}

class _Speech2textState extends State<Speech2text> {
  List<dynamic> specific_items = [],general_items = [];
  String symptom = "null";
  bool exist=false;
  void uploadFile() async {
    for(var symps in widget.specific.keys){
      if(widget.specific[symps])
      specific_items.add(symps);
    }
    for(var symps in widget.general.keys){
      if(widget.general[symps])
      general_items.add(symps);
    }
    print(specific_items);
    print(general_items);
  }
  Future<String> get _localPath async {
    Directory? appDir = await getExternalStorageDirectory();
    Directory appDirec = Directory("${appDir!.path}/Audiorecords/${widget.id}_${widget.name}/EHR");
    if (!await appDirec.exists()) {
        appDirec.create(recursive: true);
    } 
    return appDirec.path;
  }

  void createFile(String users,Directory dir)
  {
    File file = new File(dir.path);
    try{
      file.createSync();
      file.writeAsString(users,mode: FileMode.write);
      print(users);
      setState(() {
        exist=true;
      });
    }catch(e){
      print("hello");
    }
  }
  
  void check() async{
    Directory? appDir = await getExternalStorageDirectory();
    Directory appDirec = Directory("${appDir!.path}/Audiorecords/${widget.id}_${widget.name}/EHR");
    if (!await appDirec.exists()) {
        appDirec.create(recursive: true);
    }
    appDirec=Directory("{$appDirec}/Session{$widget.num}");
    bool fileExists = await File(appDirec.path).exists();
    print(fileExists);
    if (!fileExists) {
        setState(() {
          exist=false;
        });
    }else{
      setState(() {
      exist=true;
    });
    }
  }
  void _saveEHR() async{
    FirebaseFirestore.instance.collection(widget.hospital_id).doc(widget.dep).collection(widget.id+"_"+widget.name+"_"+widget.phone+"_"+widget.gender+"_"+widget.age).doc("session"+widget.num.toString()).set({"Specific":specific_items,"General":general_items,"Doctor":widget.doc_name,"Doctor ID":widget.doctor_id,"Department":widget.dep});
    FirebaseFirestore.instance.collection(widget.hospital_id).doc("Global").collection(widget.id+"_"+widget.name+"_"+widget.phone+"_"+widget.gender+"_"+widget.age).doc("session"+widget.num.toString()).set({"Specific":specific_items,"General":general_items,"Doctor":widget.doc_name,"Doctor ID":widget.doctor_id,"Department":widget.dep});
    final path = await _localPath;
    final filename = "Session"+widget.num.toString();
    final file = Directory('$path/$filename.txt');
    var tempPath=file.path.toString();
    final currentFile = File(tempPath);

    String specific="";
    for(var symps in specific_items){
      specific+=symps+",";
    }
    if (specific.length > 0) {
      specific = specific.substring(0, specific.length - 1);
    }
    
    String general="";
    for(var symps in general_items){
      general+=symps+",";
    }

    if (general.length > 0) {
      general = general.substring(0, general.length - 1);
    }

    String symptoms=specific+" - "+general;
    try{
      currentFile.writeAsString(symptoms,mode: FileMode.write);
      print(symptoms);
      setState(() {
        exist=true;
      }); 
    }catch(e){
      print("hi");
      createFile(symptoms, file);
    }
  }

  @override
  void initState() {
    super.initState();
    uploadFile();
    check();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
            height: height,
            width: width,
            child:SingleChildScrollView(
                                  child: Column(children: [
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
                  "E H R",
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
          height: 30,
        ),
                      
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
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
                        padding: const EdgeInsets.only(left:8.0),
                        child: Row(
                          children: [
                            ElevatedButton(
                      child: Container(
              height: 40.0,
              width: exist?180.0:80.0,
              child: Padding(
                padding: const EdgeInsets.only(
                        left: 3.0, right: 3.0, top: 8.0, bottom: 8.0),
                child: Row(
                      children: [
                        exist?Text("Overwrite Saved EHR"):Text("Save"),
                        SizedBox(width: 15.0),
                        Icon(
                          exist?FontAwesomeIcons.arrowAltCircleRight:FontAwesomeIcons.save,
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
             onPressed: () => _saveEHR()
                        ),
                          ],
                        ),
                      ),
                  SizedBox(
                        height: 50.0,
                      ),
                      Text("Symptoms",
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
                      Text("General Symptoms",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0)),
                      SizedBox(height: 20.0),
                      general_items.length!=0?
                      Wrap(
                          //alignment: WrapAlignment.spaceBetween,
                          direction: Axis.horizontal,
                          children:<Widget>[
                            for(var item in general_items)
                      Padding(
                          padding: const EdgeInsets.only(top:8.0,right:8.0),
                          child: Container(
                            height: 40.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 8.0,bottom: 8.0),
                                  child: Text(item,style: TextStyle(fontSize: 20.0,color: Colors.white,)),
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
                      ),
                          ],
                      )
                      :Container(
                          height: 30.0,
                          child: Text("No Text Extracted")),    
                      SizedBox(height: 20.0),
                      Text("Specific Symptoms",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0)),
                      SizedBox(height: 20.0),
                      specific_items.length!=0?
                      Wrap(
                          //alignment: WrapAlignment.spaceBetween,
                          direction: Axis.horizontal,
                          children:<Widget>[
                            for(var item in specific_items)
                      Padding(
                          padding: const EdgeInsets.only(top:8.0,right:8.0),
                          child: Container(
                            height: 40.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 8.0,bottom: 8.0),
                                  child: Text(item,style: TextStyle(fontSize: 20.0,color: Colors.white,)),
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
                      )
                          ],
                      )
                      :Container(
                          height: 30.0,
                          child: Text("No Text Extracted")),
                          ],),
                        )
                        ,)  
                    ]),
                )
                ));
  }

}