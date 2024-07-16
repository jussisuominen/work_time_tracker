import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:work_time_tracker/working_session_model.dart';

void main() {
  initializeDateFormatting();
  runApp(const MainApp());
}

const Map<String, String> finnishLabels = {
  'appTitle': 'Työskentelyajan seuranta',
  'startWorking': 'Aloita työskentely',
  'stopWorking': 'Lopeta työskentely',
  'youStartedWorking': 'Aloitit työskentelyn',
  'youStoppedWorking': 'Lopetit työskentelyn',
  'youWorked': 'Työskentelit',
  'hours': 'tuntia',
  'minutes': 'minuuttia',
  'seconds': 'sekuntia'
};

const Map<String, String> labels = finnishLabels;

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<WorkingSessionModel> _workingSessions = [];
  late WorkingSessionModel _currentWorkingSession;
  bool working = false;
  late DateFormat dateFormat;

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
    setState(() {
      _currentWorkingSession.stoppedWorking = DateTime.now();
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

    String youWorkedLabel = labels['youWorked']!;
    String hoursLabel = labels['hours']!;
    String minutesLabel = labels['minutes']!;
    String secondsLabel = labels['seconds']!;

    if (_currentWorkingSession.stoppedWorking != null) {
      _currentWorkingSession.workDuration = _currentWorkingSession
          .stoppedWorking!
          .difference(_currentWorkingSession.workStarted!);
    }

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
                  Text(
                      [
                        '${labels['youStartedWorking']!}: ${dateFormat.format(workingSession.workStarted!)}.',
                        if (workingSession.stoppedWorking != null)
                          '${labels['youStoppedWorking']!}: ${dateFormat.format(workingSession.stoppedWorking!)}.\n\n',
                        if (workingSession.stoppedWorking != null)
                          '$youWorkedLabel ${workingSession.workDuration!.inHours} $hoursLabel ${workingSession.workDuration!.inMinutes} $minutesLabel, ${workingSession.workDuration!.inSeconds} $secondsLabel\n'
                      ].join(),
                      style: Theme.of(context).textTheme.titleLarge),
              startWorkingButton,
            ],
          ),
        ),
      ),
    ));
  }
}
