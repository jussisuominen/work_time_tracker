import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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
  final List<WorkingSessionModel> _workingSessions = [];
  late WorkingSessionModel _currentWorkingSession;
  bool working = false;
  late DateFormat dateFormat;
  Duration _timeUsedToday = const Duration();

  @override
  void initState() {
    super.initState();
    dateFormat = DateFormat.jms('fi');
    _currentWorkingSession = WorkingSessionModel();
    _workingSessions.add(_currentWorkingSession);
  }

  void startWorking() {
    _currentWorkingSession = WorkingSessionModel();
    _workingSessions.add(_currentWorkingSession);
    setState(() {
      _currentWorkingSession.workStarted = DateTime.now();
      working = true;
    });
  }

  void stopWorking() {
    _currentWorkingSession.stoppedWorking = DateTime.now();
    _currentWorkingSession.workDuration = _currentWorkingSession.stoppedWorking!
        .difference(_currentWorkingSession.workStarted!);

    _timeUsedToday += _currentWorkingSession.workDuration!;

    setState(() {
      working = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Text appTitle = Text(labels['appTitle']!,
        style: Theme.of(context).textTheme.displayMedium);

    final ElevatedButton startWorkingButton = ElevatedButton(
        onPressed: working ? stopWorking : startWorking,
        child: working
            ? Text(labels['stopWorking']!,
                style: Theme.of(context).textTheme.titleMedium)
            : Text(labels['startWorking']!,
                style: Theme.of(context).textTheme.titleMedium));

    // if (_currentWorkingSession.stoppedWorking != null) {
    //   _currentWorkingSession.workDuration = _currentWorkingSession
    //       .stoppedWorking!
    //       .difference(_currentWorkingSession.workStarted!);
    // }

    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              appTitle,
              const SizedBox(
                height: 10,
              ),
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
                label: 'Olet työskennellyt tänään',
                andLabel: labels['and']!,
                hoursLabel: labels['hours']!,
                minutesLabel: labels['minutes']!,
                secondsLabel: labels['seconds']!,
                timeUsed: _timeUsedToday,
              ),
              const Divider(),
              startWorkingButton,
            ],
          ),
        ),
      ),
    ));
  }
}
