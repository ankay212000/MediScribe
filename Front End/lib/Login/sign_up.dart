import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech2text/Pages/confirm_form.dart';
import 'package:speech2text/Utility/theme.dart';
import 'package:speech2text/Pages/home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SignUp extends StatefulWidget {
  final doctor_id;
  final hospital_id;
  final doc_name;
  final dep;
  SignUp({this.doctor_id,this.hospital_id,this.doc_name,this.dep});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode focusNodePhone = FocusNode();
  final FocusNode focusNodeName = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var gender = "Male";
  DateTime selectedDate = DateTime.now();
  String showDate="Date of Birth";
  String showText="Gender";
  String? result;
  int found=-1;

  int id = 1;

  Future<String> get _localPath async {
    Directory? appDir = await getExternalStorageDirectory();
    Directory appDirec = Directory("${appDir!.path}");
    return appDirec.path;
  }

  Future<Directory> get _localFile async {
    final path = await _localPath;
    return Directory('$path/Patient ID.txt');
  }

  Future<String> readContent() async {
    final file = await _localFile;
    var tempPath=file.path.toString();
    final currentFile = File(tempPath);
    try {
      String contents = await currentFile.readAsString();
      setState(() {
        id = int.parse(contents);
        print(contents);
      });
      return contents;
    } catch (e) {
      print(e);
      return 'Error';
    }
  }

  Future<File> writeContent() async {
    final file = await _localFile;
    var tempPath=file.path.toString();
    final currentFile = File(tempPath);
    return currentFile.writeAsString((id+1).toString());
  }

  @override
  void initState() {
    super.initState();
    readContent();
    _readfromDB();
  }


  void createFile(String users,Directory dir)
  {
    File file = new File(dir.path);
    try{
      file.createSync();
      file.writeAsString(users,mode: FileMode.append);
    }catch(e){
      print(e);
    }
  }
  void _addtoDB() async{
    //add to patient to database
    final path = await _localPath;
    final file = Directory('$path/Patients.txt');
    var tempPath=file.path.toString();
    final currentFile = File(tempPath);

    String users=id.toString()+":"+nameController.text+":"+phoneController.text+":"+showDate.toString().split(' ')[0]+":"+gender+",";
    
    try{
      currentFile.writeAsString(users,mode: FileMode.append); 
    }catch(e){
      print(e);
      createFile(users, file);
    }
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
      print(e);
    }
  }

  bool check(){
    _readfromDB();
    int len=(users==null?0:users.length);
    print(len);
    for(int i=0;i<len-1;i++)
    {
      if(users[i].split(":")[1]==nameController.text&&users[i].split(":")[2]==phoneController.text&&users[i].split(":")[3]==showDate.split(" ")[0].toString()&&users[i].split(":")[4]==gender)
      {
        print("Im hre\n");
        found=int.parse(users[i].split(":")[0]);
        return true;
      }
    }
    return false;
  }
  _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2022),
        helpText: "Select Date of Birth",
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter date in valid range',
        fieldLabelText: 'Date of Birth');
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        showDate=picked.toString();
        print(showDate);
      });
  }

  @override
  void dispose() {
    focusNodePhone.dispose();
    focusNodeName.dispose();
    super.dispose();
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
                  width: 320.0,
                  height: 420.0,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height:20.0),
                      Row(
                      children: [
                        SizedBox(width:30.0),
                        Text("ID",style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 20.0,fontWeight: FontWeight.bold),),
                        SizedBox(width: 20.0,),
                        Text(id.toString(),style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0))
                      ],
                      ),
                      SizedBox(height: 20.0,),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: focusNodeName,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          autocorrect: false,
                          style: const TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            hintText: 'Name',
                            hintStyle: TextStyle(
                                fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                          ),
                          onSubmitted: (_) {
                            focusNodeName.requestFocus();
                          },
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: focusNodePhone,
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          autocorrect: false,
                          style: const TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.mobile,
                              color: Colors.black,
                            ),
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(
                                fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                          ),
                          onSubmitted: (_) {
                            focusNodePhone.requestFocus();
                          },
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: RawMaterialButton(
                          onPressed: () => _selectDate(context),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.birthdayCake,
                                color: Colors.black,
                              ),
                              SizedBox(width: 20),
                              Text(
                                showDate=="Date of Birth"?showDate:showDate.toString().split(' ')[0],
                                style: TextStyle(
                                    color: showDate=="Date of Birth"?Colors.grey[600]:Colors.black,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 10.0),
                      DropdownButton(
                        hint: Text(showText),
                        //value: gender,
                        items: [
                          DropdownMenuItem(
                            child: Text("Male"),
                            value: "Male",
                          ),
                          DropdownMenuItem(
                            child: Text("Female"),
                            value: "Female",
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                            showText=gender;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 60.0,),
                  Row(
                    children: [
                      SizedBox(width: 46.0),
                      Container(
                        width: 300.0,
                        margin: const EdgeInsets.only(top: 340.0),
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
                              SizedBox(width: 90.0),
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
                            if (nameController.text =="")
                              {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Missing Information"),
                                    content:
                                        Text("Name required !!!!"),
                                    actions: <Widget>[
                                      RawMaterialButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("Okay"),
                                      ),
                                    ],
                                  ),
                                )
                              }
                              else if (phoneController.text =="")
                              {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Missing Information"),
                                    content:
                                        Text("Phone number required !!!!"),
                                    actions: <Widget>[
                                      RawMaterialButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("Okay"),
                                      ),
                                    ],
                                  ),
                                )
                              }
                              else if (showDate =="Date of Birth")
                              {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Missing Information"),
                                    content:
                                        Text("Date of Birth required !!!!"),
                                    actions: <Widget>[
                                      RawMaterialButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("Okay"),
                                      ),
                                    ],
                                  ),
                                )
                              }
                              else if (showText =="Gender")
                              {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Missing Information"),
                                    content:
                                        Text("Gender required !!!!"),
                                    actions: <Widget>[
                                      RawMaterialButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("Okay"),
                                      ),
                                    ],
                                  ),
                                )
                              }
                              else{
                                if(!check())
                                {
                                  _addtoDB(),
                                  readContent(),
                                writeContent(),
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: HomePage(
                                          dep: widget.dep,
                                          doc_name: widget.doc_name,
                                          doctor_id: widget.doctor_id,
                                          hospital_id: widget.hospital_id,
                                          id: id.toString(),
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          age: showDate.toString().split(" ")[0],
                                          gender: gender,
                                        )))
                                }else{
                                  showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Already registered"),
                                    content:
                                        Text("Patient ID ${found}"),
                                    actions: <Widget>[
                                      RawMaterialButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("Okay"),
                                      ),
                                    ],
                                  ),
                                )
                                }
                              }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
