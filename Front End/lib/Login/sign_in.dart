import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech2text/Pages/Conversation.dart';
import 'package:speech2text/Pages/confirm_form.dart';
import 'package:speech2text/Pages/text.dart';
import 'package:speech2text/Utility/theme.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:speech2text/Pages/home.dart';

class SignIn extends StatefulWidget {
  final doctor_id;
  final hospital_id;
  final doc_name;
  final dep;
  SignIn({this.doctor_id,this.hospital_id,this.doc_name,this.dep});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();
  String selected = "";
  Map<String, bool?> specific_items = {"null": false};
  Map<String, bool?> general_items = {"null": false};
  bool exist=false;
  void changeName(String txt) {
    setState(() {
      selected = txt;
    });
  }

  Future<String> get _localPath async {
    Directory? appDir = await getExternalStorageDirectory();
    Directory appDirec = Directory("${appDir!.path}");
    return appDirec.path;
  }

  var users;
  void _readfromDB() async{
    final path = await _localPath;
    final file = Directory('$path/Patients.txt');
    var tempPath=file.path.toString();
    final currentFile = File(tempPath);
    try{
      var temp = await currentFile.readAsString();
      users = temp.toString().split(",");
    }catch(e){
      print("error: ");
    }
  }

  Future<String> readContent(int id,String name,String file) async {
    Directory? appDir = await getExternalStorageDirectory();
    Directory appDirec = Directory("$file");
    print(appDirec);
    var tempPath=appDirec.path.toString();
    final currentFile = File(tempPath);
    try {
      String contents = await currentFile.readAsString();
      setState(() {
        List<String> symptoms = contents.split("-");
        List<String> specific = symptoms[0].split(",");
        List<String> general = symptoms[1].split(",");
        general_items = {"null": false};
        specific_items = {"null": false};
        for (var symp in specific) {
          specific_items[symp] = true;
        }
        for (var symp in general) {
          general_items[symp] = true;
        }
        specific_items.remove("null");
        general_items.remove("null");
        print(specific_items);
        print(general_items);
      });
      return contents;
    } catch (e) {
      print(e);
      return 'Error';
    }
  }

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _readfromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  //color: Colors.black,
                  height: 520.0,
                  child: Expanded(
                                      child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
                          child: Container(
                            height: 470.0,
                            width: 500,
                            child: users!=null?ListView.builder(
                                itemCount: users.length-1,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int i) {
                                  return ExpansionTile(
                                      title: Text("Patient Id ${users[i].split(":")[0]}",style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 20.0,fontWeight: FontWeight.bold)),
                                      children: [
                                        Column(children: [
                                          Row(
                                        children: [
                                          SizedBox(width:30.0),
                                          Text("Name: ",style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 20.0,fontWeight: FontWeight.bold),),
                                          SizedBox(width: 20.0,),
                                          Text(users[i].split(":")[1],style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0))
                                        ],
                                        ),
                                        Row(
                                        children: [
                                          SizedBox(width:30.0),
                                          Text("Phone Number: ",style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 20.0,fontWeight: FontWeight.bold),),
                                          SizedBox(width: 20.0,),
                                          Text(users[i].split(":")[2],style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0))
                                        ],
                                        ),
                                        Row(
                                        children: [
                                          SizedBox(width:30.0),
                                          Text("D.O.B: ",style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 20.0,fontWeight: FontWeight.bold),),
                                          SizedBox(width: 20.0,),
                                          Text(users[i].split(":")[3],style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0))
                                        ],
                                        ),
                                        Row(
                                        children: [
                                          SizedBox(width:30.0),
                                          Text("Gender: ",style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 20.0,fontWeight: FontWeight.bold),),
                                          SizedBox(width: 20.0,),
                                          Text(users[i].split(":")[4],style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0))
                                        ],
                                        ),
                                        Row(
                      children: [
                        SizedBox(width: 46.0),
                        Container(
                          width: 133.0,
                          margin: const EdgeInsets.only(top: 50.0,bottom: 30.0),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Color(0xffb296C92),
                                  offset: Offset(-1.0, 5.0),
                                  blurRadius: 8.0,
                                ),
                              ],
                              color: Colors.blue),
                          child: MaterialButton(
                            highlightColor: Colors.transparent,
                            splashColor: CustomTheme.loginGradientEnd,
                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.microphone,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  'Record',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontFamily: 'WorkSansBold'),
                                ),
                              ],
                            ),
                            onPressed: () => {
                              Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomePage(
                                      doctor_id: widget.doctor_id,
                                      dep: widget.dep,
                                      hospital_id: widget.hospital_id,
                                      doc_name: widget.doc_name,
                                      id: users[i].split(":")[0],
                                      name:users[i].split(":")[1],
                                      phone: users[i].split(":")[2],
                                      age:users[i].split(":")[3],
                                      gender: users[i].split(":")[4],)),
                                  )
                            },
                          ),
                        ),
                        SizedBox(width: 35.0),
                        Container(
                          width: 133.0,
                          margin: const EdgeInsets.only(top: 50.0,bottom: 30.0),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Color(0xffb296C92),
                                  offset: Offset(-1.0, 5.0),
                                  blurRadius: 8.0,
                                ),
                              ],
                              color: Colors.blue),
                          child: MaterialButton(
                            highlightColor: Colors.transparent,
                            splashColor: CustomTheme.loginGradientEnd,
                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.fileAudio,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  'Pick Session',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontFamily: 'WorkSansBold'),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              Directory? appDir = await getExternalStorageDirectory();
                              String jrecord = 'Audiorecords';
                              Directory appDirec =
                                  Directory("${appDir!.path}/$jrecord/${users[i].split(":")[0]}_${users[i].split(":")[1]}");
                              String? path = await FilesystemPicker.open(
                                title: 'Open file',
                                context: context,
                                rootDirectory: appDirec,
                                fsType: FilesystemType.file,
                                folderIconColor: Colors.teal,
                                allowedExtensions: ['.wav'],
                                fileTileSelectMode: FileTileSelectMode.wholeTile,
                              );
                              if (path == null) return;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => conversation(
                                    dep: widget.dep,
                                    doctor_id: widget.doctor_id,
                                    hospital_id: widget.hospital_id,
                                    doc_name: widget.doc_name,
                                    filename: path,
                                    name: users[i].split(":")[1],
                                    phone: users[i].split(":")[2],
                                    age: users[i].split(":")[3],
                                    gender: users[i].split(":")[4],)));
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                          width: 133.0,
                          margin: const EdgeInsets.only(top: 10.0,bottom: 30.0),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Color(0xffb296C92),
                                  offset: Offset(-1.0, 5.0),
                                  blurRadius: 8.0,
                                ),
                              ],
                              color: Colors.blue),
                          child: MaterialButton(
                            highlightColor: Colors.transparent,
                            splashColor: CustomTheme.loginGradientEnd,
                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.fileAudio,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  'Saved EHR',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontFamily: 'WorkSansBold'),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              Directory? appDir = await getExternalStorageDirectory();
                              String jrecord = 'Audiorecords';
                              Directory appDirec =
                                  Directory("${appDir!.path}/$jrecord/${users[i].split(":")[0]}_${users[i].split(":")[1]}/EHR");
                              String? path = await FilesystemPicker.open(
                                title: 'Open file',
                                context: context,
                                rootDirectory: appDirec,
                                fsType: FilesystemType.file,
                                folderIconColor: Colors.teal,
                                allowedExtensions: ['.txt'],
                                fileTileSelectMode: FileTileSelectMode.wholeTile,
                              );
                              if (path == null) return;
                              String res=await readContent(int.parse(users[i].split(":")[0]), users[i].split(":")[1], path);
                              if(res!="Error")
                              {
                                String tempName=path.split("/").last.split(".")[0];
                                String tempNum=tempName[tempName.length-1];
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Speech2text(
                                    dep: widget.dep,
                                    doctor_id: widget.doctor_id,
                                    hospital_id: widget.hospital_id,
                                    doc_name: widget.doc_name,
                                    num: int.parse(tempNum),
                                    id:users[i].split(":")[0],
                                    specific: specific_items,
                                    general: general_items,
                                    name: users[i].split(":")[1],
                                    phone: users[i].split(":")[2],
                                    age: users[i].split(":")[3],
                                    gender: users[i].split(":")[4],)));
                              }
                            },
                          ),
                        ),
                                        ],)
                                      ],
                                      );
                                }):Center(child: Text("No Patients",style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 20.0,fontWeight: FontWeight.bold))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*Widget getButton(String buttonName, bool isSelected) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.5,
      height: height * 0.07,
      decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.blue,
          border: Border.all(color: Colors.blueAccent),
          borderRadius: const BorderRadius.all(Radius.circular(24.0))),
      //border: Border.all(color: Colors.green)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          splashColor: Colors.white24,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          onTap: () {
            setState(() {
              changeName(buttonName);
              if (buttonName == "Session") {
                //pageroute
              } else if (buttonName == "Bhul Gya") {
                //pageroute
              } else {
                //pageroute
              }
            });
          },
          child: Center(
            child: Text(
              buttonName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                letterSpacing: 0.27,
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }*/
}
