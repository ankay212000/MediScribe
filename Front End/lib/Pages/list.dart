import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:speech2text/Pages/Conversation.dart';
import 'package:speech2text/Pages/confirm_form.dart';
import 'text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class Records extends StatefulWidget {
  final List<String> records;
  final doctor_id;
  final hospital_id;
  final doc_name;
  final dep;
  final id;
  final name;
  final age;
  final phone;
  final gender;
  const Records(
      {Key? key,
      this.id,
      required this.records,
      this.doctor_id,
      this.hospital_id,
      this.doc_name,
      this.name,
      this.age,
      this.phone,
      this.dep,
      this.gender})
      : super(key: key);

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  late int _totalTime;
  late int _currentTime;
  double _percent = 0.0;
  int _selected = -1;
  bool isPlay = false;
  int diff=0;
  String showText="English";
  String lang="en-IN";
  void check() async{
    Directory? appDir = await getExternalStorageDirectory();
    Directory appDirec = Directory("${appDir!.path}/Audiorecords/${widget.id}_${widget.name}/EHR");
    print(appDirec);
    if (!await appDirec.exists()) {
        setState(() {
          diff=0;
        });
    }else{
      setState(() {
      diff=1;
    });
    }
  }
  
  AudioPlayer advancedPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    check();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        itemCount: widget.records.length-diff,
        shrinkWrap: true,
        reverse: false,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            elevation: 5,
            child: ExpansionTile(
              title: Text(
                'Session ${i+1}',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                _getTime(filePath: widget.records.elementAt(i)),
                style: TextStyle(color: Colors.black38),
              ),
              onExpansionChanged: ((newState) {
                if (newState) {
                  setState(() {
                    _selected = i;
                  });
                }
              }),
              children: [
                Container(
          height: 150,
          padding: const EdgeInsets.only(left:10.0,right: 10.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text("Language: "),
                  SizedBox(width:10.0),
                  DropdownButton(
                    hint: Text(showText),
                    //value: gender,
                    items: [
                      DropdownMenuItem(
                        child: Text("English"),
                        value: "English",
                      ),
                      DropdownMenuItem(
                        child: Text("Hindi"),
                        value: "Hindi",
                      ),
                      ],
                    onChanged: (value) {
                      setState(() {
                        lang = value.toString()=="English"?"en-IN":"hi-IN";
                        showText=value.toString();
                      });
                    },
                  ),
                ],
              ),
              LinearProgressIndicator(
                minHeight: 5,
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                value: _selected == i ? _percent : 0,
              ),
              Row(
                children: [
                  (isPlay)
                      ? _Presso(
                          ico: Icons.pause,
                          onPressed: () {
                            setState(() {
                              isPlay = false;
                            });
                            advancedPlayer.pause();
                          })
                      : _Presso(
                          ico: Icons.play_arrow,
                          onPressed: () {
                            setState(() {
                              isPlay = true;
                            });
                            advancedPlayer.play(
                                widget.records.elementAt(i),
                                isLocal: true);
                            setState(() {});
                            setState(() {
                              print(widget.records.elementAt(i));
                              _selected = i;
                              _percent = 0.0;
                            });
                            advancedPlayer.onPlayerCompletion
                                .listen((_) {
                              setState(() {
                                _percent = 0.0;
                              });
                            });
                            advancedPlayer.onDurationChanged
                                .listen((duration) {
                              setState(() {
                                _totalTime = duration.inMicroseconds;
                              });
                            });
                            advancedPlayer.onAudioPositionChanged
                                .listen((duration) {
                              setState(() {
                                _currentTime = duration.inMicroseconds;
                                _percent = _currentTime.toDouble() /
                                    _totalTime.toDouble();
                              });
                            });
                          }),
                  _Presso(
                      ico: Icons.stop,
                      onPressed: () {
                        advancedPlayer.stop();
                        setState(() {
                          _percent = 0.0;
                        });
                      }),
                  _Presso(
                      ico: Icons.delete,
                      onPressed: () {
                        Directory appDirec =
                            Directory(widget.records.elementAt(i));
                        appDirec.delete(recursive: true);
                        Fluttertoast.showToast(msg: "File Deleted");
                        setState(() {
                          widget.records
                              .remove(widget.records.elementAt(i));
                        });
                      }),
                  _Presso(
                      ico: Icons.arrow_forward,
                      onPressed: () {
                        Directory appDirec =
                            Directory(widget.records.elementAt(i));
                        List<String> list = List.empty(growable: true);
                        list.add(appDirec.path);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                conversation(
                                  language: lang,
                                  dep: widget.dep,
                                  doctor_id: widget.doctor_id,
                            hospital_id: widget.hospital_id,
                            doc_name: widget.doc_name,
                                  id: widget.id,
                                  num: i+1,
                                  filename: list[0],name: widget.name,
                          phone: widget.phone,
                          age: widget.age,
                          gender: widget.gender,)));
                      }),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ],
          ),
        )
              ],
            ),
          );
        },
      ),
    );
  }

  String _getTime({required String filePath}) {
    String fromPath = filePath.split("/").last.split(".")[0];
    if (fromPath.startsWith("1", 0)) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(fromPath));
      int year = dateTime.year;
      int month = dateTime.month;
      int day = dateTime.day;
      int hour = dateTime.hour;
      int min = dateTime.minute;
      String dato = '$year-$month-$day--$hour:$min';
      return dato;
    } else {
      return "No Date";
    }
  }
}

class _Presso extends StatelessWidget {
  final IconData ico;
  final VoidCallback onPressed;

  const _Presso({Key? key, required this.ico, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 48.0,
      child: RawMaterialButton(
          child: Icon(
            ico,
            color: Colors.black,
          ),
          shape: CircleBorder(),
          onPressed: onPressed),
    );
  }
}
