import 'dart:async';
import 'dart:io' as io;

import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:parrot_flutter/components/headerNav.dart';
import 'package:parrot_flutter/variables/variables.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  return runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: SafeArea(
          child: new RecorderExample(),
        ),
      ),
    );
  }
}

class RecorderExample extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  RecorderExample({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new RecorderExampleState();
}

class RecorderExampleState extends State<RecorderExample> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  IconData iconData = Icons.mic;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: headerNav(title: 'Recording'),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new RawMaterialButton(
                        onPressed: () {
                          switch (_currentStatus) {
                            case RecordingStatus.Initialized:
                              {
                                _start();
                                setState(() {
                                  iconData = Icons.stop;
                                });
                                break;
                              }
                            case RecordingStatus.Recording:
                              {
                                _stop();
                                _init();



                                setState(() {
                                  iconData = Icons.mic;
                                });

                                break;
                              }
                            default:
                              break;
                          }
                        },
                        child: Icon(iconData, color: purplecolor, size: 80.0,),
                        elevation: 2.0,
                        fillColor: Colors.grey[200],
                        padding: EdgeInsets.all(20.0),
                        shape: CircleBorder(),
//                        _buildText(_currentStatus),
                      ),
                      SizedBox(height: 10.0,),
                      Align(alignment: Alignment.center,child: new Text(_current?.duration.toString())),
                    ],
//              new Text("File path of the record: ${_current?.path}"),
          ),
        ),
      ),
    );
  }

  TextEditingController _changeRecordingName = TextEditingController();
  String newfilename = 'NOT SET';

  _displayDialog(BuildContext context, totalnewfilename) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit recording name'),
            content: TextField(
              controller: _changeRecordingName,
              autofocus: true,
              maxLength: 20,
              maxLines: 1,
              decoration: InputDecoration(hintText: "Recording name for ex: dog",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: purplecolor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: purplecolor))
              ),

            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Save'),
                onPressed: () {
                  setState(() {
                    newfilename = _changeRecordingName.text;
                  });
                  Navigator.of(context).pop();
                  showSnackBar();
                },
              ),
            ],
          );
        });
  }

  void showSnackBar() {
    final snackBarContent = SnackBar(
      content: Text("Recorded $newfilename"),
      action: SnackBarAction(
          label: 'OK', onPressed: _scaffoldkey.currentState.hideCurrentSnackBar),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_recordings';
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.AAC);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
        var dur = _current.duration;
      });

      const tick = const Duration(milliseconds: 500);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {

    var result = await _recorder.stop();

    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);

    String fileName = file.path.split('/').last;
    print("File name: $fileName");

    await _displayDialog(context, newfilename).then((val){
      _rename(file);
    });

    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  _rename(file) async {

    print("NEW FILE NAME: $newfilename");

    String newPath = "/storage/emulated/0/Android/data/parrot.parrot_flutter/files/$newfilename.m4a";
    file.renameSync(newPath);

    print(newPath);
  }
//  void onPlayAudio() async {
//    AudioPlayer audioPlayer = AudioPlayer();
//    await audioPlayer.play(_current.path, isLocal: true);
//  }
}