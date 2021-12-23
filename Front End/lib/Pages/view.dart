import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../Utility/audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Utility/recording_animation.dart';

class Recorder extends StatefulWidget {
  final Function save;
  final doctor_id;
  final hospital_id;
  final doc_name;
  final dep;
  final name;
  final age;
  final phone;
  final gender;
  final id;
  const Recorder(
      {Key? key,
      required this.save,
      this.doctor_id,
      this.hospital_id,
      this.doc_name,
      this.dep,
      this.name,
      this.age,
      this.phone,
      this.gender,
      this.id})
      : super(key: key);
  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  IconData _recordIcon = Icons.mic_none;
  MaterialColor colo = Colors.orange;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool stop = false;
  Recording? _current;
  // Recorder properties
  late FlutterAudioRecorder? audioRecorder;
  String mainText = "Press to Begin Session";
  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  checkPermission() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }

// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();
    print(statuses[Permission.microphone]);
    print(statuses[Permission.storage]);
    //bool hasPermission = await FlutterAudioRecorder.hasPermissions ?? false;
    if (statuses[Permission.microphone] == PermissionStatus.granted) {
      _currentStatus = RecordingStatus.Initialized;
      _recordIcon = Icons.mic;
    } else {}
  }

  @override
  void dispose() {
    _currentStatus = RecordingStatus.Unset;
    audioRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
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
              height: 30,
            ),
            Text(
              mainText,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                  color: Colors.blue),
            ),
            mainText == "Recorded"
                ? Text(
                    "Press to begin again",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Montserrat',
                        color: Colors.blue),
                  )
                : SizedBox(width: 0.0),
            SizedBox(
              height: 30,
            ),
            stop == false
                ? RawMaterialButton(
                    onPressed: () async {
                      await _onRecordButtonPressed();
                      setState(() {});
                    },
                    elevation: 5.0,
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.mic_none,
                      color: Colors.black,
                      size: 100,
                    ),
                    padding: EdgeInsets.all(30.0),
                    shape: CircleBorder(),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RippleAnimation(
                          iconData: RawMaterialButton(
                            onPressed: _currentStatus != RecordingStatus.Unset
                                ? _stop
                                : null,
                            child: Icon(
                              Icons.mic,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          _recordo();
          break;
        }
      case RecordingStatus.Recording:
        {
          _pause();
          break;
        }
      case RecordingStatus.Paused:
        {
          _resume();
          break;
        }
      case RecordingStatus.Stopped:
        {
          _recordo();
          break;
        }
      default:
        break;
    }
  }

  _initial() async {
    Directory? appDir = await getExternalStorageDirectory();
    String jrecord = 'Audiorecords';
    String dato = "${DateTime.now().millisecondsSinceEpoch.toString()}.wav";
    Directory appDirec = Directory("${appDir!.path}/$jrecord");
    if (await appDirec.exists()) {
      appDirec=Directory("${appDirec.path}/${widget.id}_${widget.name}/");
      if(await appDirec.exists())
      {
        String patho = "${appDirec.path}$dato";
        print("path for file11 ${patho}");
        audioRecorder = FlutterAudioRecorder(patho, audioFormat: AudioFormat.WAV);
        await audioRecorder!.initialized;
      }else{
        appDirec.create(recursive: true);
        String patho = "${appDirec.path}$dato";
        print("path for file11 ${patho}");
        audioRecorder = FlutterAudioRecorder(patho, audioFormat: AudioFormat.WAV);
        await audioRecorder!.initialized;  
      }
    } else {
      appDirec.create(recursive: true);
      appDirec=Directory("${appDirec.path}/${widget.id}_${widget.name}/");
      if(await appDirec.exists())
      {
        Fluttertoast.showToast(msg: "Start Recording , Press Start");
        String patho = "${appDirec.path}$dato";
        print("path for file22 ${patho}");
        audioRecorder = FlutterAudioRecorder(patho, audioFormat: AudioFormat.WAV);
        await audioRecorder!.initialized;
      }else{
        appDirec.create(recursive: true);
        Fluttertoast.showToast(msg: "Start Recording , Press Start");
        String patho = "${appDirec.path}$dato";
        print("path for file22 ${patho}");
        audioRecorder = FlutterAudioRecorder(patho, audioFormat: AudioFormat.WAV);
        await audioRecorder!.initialized;  
      }
    }
  }

  _start() async {
    await audioRecorder!.start();
    var recording = await audioRecorder!.current(channel: 0);
    setState(() {
      _current = recording!;
      mainText = "Recording..";
    });

    const tick = const Duration(milliseconds: 50);
    new Timer.periodic(tick, (Timer t) async {
      if (_currentStatus == RecordingStatus.Stopped) {
        t.cancel();
      }

      var current = await audioRecorder!.current(channel: 0);
      // print(current.status);
      setState(() {
        _current = current!;
        _currentStatus = _current!.status!;
      });
    });
  }

  _resume() async {
    await audioRecorder!.resume();
    Fluttertoast.showToast(msg: "Resume Recording");
    setState(() {
      _recordIcon = Icons.pause;
      colo = Colors.red;
    });
  }

  _pause() async {
    await audioRecorder!.pause();
    Fluttertoast.showToast(msg: "Pause Recording");
    setState(() {
      _recordIcon = Icons.mic;
      colo = Colors.green;
    });
  }

  _stop() async {
    var result = await audioRecorder!.stop();
    Fluttertoast.showToast(msg: "Stop Recording , File Saved");
    widget.save();
    setState(() {
      _current = result!;
      _currentStatus = _current!.status!;
      _current!.duration = null;
      _recordIcon = Icons.mic;
      stop = false;
      mainText = "Recorded";
    });
  }

  Future<void> _recordo() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();
    print(statuses[Permission.microphone]);
    print(statuses[Permission.storage]);
    //bool hasPermission = await FlutterAudioRecorder.hasPermissions ?? false;
    if (statuses[Permission.microphone] == PermissionStatus.granted) {
      /* }
    bool hasPermission = await FlutterAudioRecorder.hasPermissions ?? false;

    if (hasPermission) {*/
      await _initial();
      await _start();
      Fluttertoast.showToast(msg: "Start Recording");
      setState(() {
        _currentStatus = RecordingStatus.Recording;
        _recordIcon = Icons.pause;
        colo = Colors.red;
        stop = true;
      });
    } else {
      Fluttertoast.showToast(msg: "Allow App To Use Mic");
    }
  }
}