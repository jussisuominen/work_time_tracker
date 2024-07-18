import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_time_tracker/logger.dart';

import 'package:work_time_tracker/widgets/time_used_view.dart';
import 'package:work_time_tracker/working_session_model.dart';
import 'package:work_time_tracker/working_session_view.dart';
import 'package:work_time_tracker/label_texts.dart';

void main() {
  initializeDateFormatting();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<WorkingSessionModel> _workingSessions = [];
  WorkingSessionModel? _currentWorkingSession;
  bool working = false;
  late DateFormat dateFormat;
  Duration _timeUsedToday = const Duration();

  @override
  void initState() {
    super.initState();

    dateFormat = DateFormat.jms('fi');
    // _currentWorkingSession = WorkingSessionModel();
    // _workingSessions.add(_currentWorkingSession);

    // Remove the comment from clearWorkingTimeData() when you want to clear
    // unnecessary working time data.
    //clearWorkingTimeData();
    loadWorkingTimeData();
  }

  void loadWorkingTimeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? workingTimeData = prefs.getString('working_time_data');

    if (workingTimeData != null) {
      final data = jsonDecode(workingTimeData);
      for (dynamic item in data) {
        _workingSessions.add(WorkingSessionModel.fromJson(item));
      }
    }

    for (WorkingSessionModel workingSession in _workingSessions) {
      _timeUsedToday += workingSession.workDuration!;
    }

    logger.d(_workingSessions);

    setState(() {});
  }

  void clearWorkingTimeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('working_time_data');

    setState(() {
      _currentWorkingSession = null;
      _workingSessions = [];
      _timeUsedToday = const Duration();
      working = false;
    });
  }

  void startWorking() {
    _currentWorkingSession = WorkingSessionModel();
    _workingSessions.add(_currentWorkingSession!);
    setState(() {
      _currentWorkingSession!.workStarted = DateTime.now();
      working = true;
    });
  }

  void stopWorking() async {
    _currentWorkingSession!.stoppedWorking = DateTime.now();
    // Calculate how much time user used for working.
    _currentWorkingSession!.workDuration = _currentWorkingSession!
        .stoppedWorking!
        .difference(_currentWorkingSession!.workStarted!);

    _timeUsedToday += _currentWorkingSession!.workDuration!;

    // Save working time data to shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await prefs.setString('working_time_data', jsonEncode(_workingSessions));
      logger.d('Working time data saved successfully :)');
    } catch (e) {
      logger.d('Something went wrong when trying to save working time data.');
    }

    setState(() {
      working = false;
    });

    logger.d(jsonEncode(_workingSessions));
  }

  @override
  Widget build(BuildContext context) {
    final Text appTitle = Text(labels['appTitle']!,
        style: Theme.of(context).textTheme.displayMedium);

    final OutlinedButton startStopWorkingButton = OutlinedButton(
        onPressed: working ? stopWorking : startWorking,
        child: working
            ? Text(labels['stopWorking']!,
                style: Theme.of(context).textTheme.titleMedium)
            : Text(labels['startWorking']!,
                style: Theme.of(context).textTheme.titleMedium));

    final ElevatedButton clearDataButton = ElevatedButton(
        onPressed: clearWorkingTimeData,
        child: Text(labels['clearData']!,
            style: Theme.of(context).textTheme.titleMedium));

    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appTitle,
                const SizedBox(
                  height: 10,
                ),
                // Working sessions
                for (WorkingSessionModel workingSession in _workingSessions)
                  if (workingSession.workStarted != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: WorkingSessionView(
                        workingSession: workingSession,
                      ),
                    ),
                const Divider(),
                TimeUsedView(
                  label: labels['youHaveWorkedToday']!,
                  andLabel: labels['and']!,
                  hoursLabel: labels['hours']!,
                  minutesLabel: labels['minutes']!,
                  secondsLabel: labels['seconds']!,
                  timeUsed: _timeUsedToday,
                ),
                const Divider(),
                startStopWorkingButton,
                const SizedBox(height: 20),
                clearDataButton
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
