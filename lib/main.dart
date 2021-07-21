import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<StepCount> _stepCountStream;
  bool flag = false;
  bool first = true;
  late StreamSubscription<dynamic> _subscribtion;
  int _step=0;
  @override
  void initState() {

    super.initState();
    check();
  }


  @override
  void dispose() {
    _subscribtion.cancel();
    super.dispose();

  }
  void check() async
  {
    if(await Permission.activityRecognition.request().isGranted)
      {

      }
    else
      {
        Permission.activityRecognition.request();
      }
  }

  @override
  void stepCount(StepCount event) {
    print(event);
    setState(() {
      _step = event.steps;
      print(_step);
    });

  }
  void _onError(error) => print("Flutter Pedometer Error: $error");

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('S4S Test'),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_step.toString()),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    flag = !flag;
                    if (first == true) {
                      _stepCountStream =Pedometer.stepCountStream;
                      _subscribtion = _stepCountStream.listen(stepCount,
                          onError: _onError);
                      first = false;
                    } else if (first == false && flag == false) {
                      _subscribtion.pause();

                    } else {
                      _subscribtion.resume();
                    }
                  });
                },
                child: Text(
                  (flag == false) ? 'Start' : 'Stop',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
