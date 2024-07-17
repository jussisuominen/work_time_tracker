import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_time_tracker/label_texts.dart';
import 'package:work_time_tracker/widgets/display_time_view.dart';
import 'package:work_time_tracker/widgets/time_used_view.dart';
import 'package:work_time_tracker/working_session_model.dart';

class WorkingSessionView extends StatelessWidget {
  final WorkingSessionModel workingSession;

  const WorkingSessionView({super.key, required this.workingSession});

  @override
  Widget build(BuildContext context) {
    String youWorkedLabel = labels['youWorked']!;
    String hoursLabel = labels['hours']!;
    String minutesLabel = labels['minutes']!;
    String secondsLabel = labels['seconds']!;
    return Wrap(
      children: [
        DisplayTimeView(
          label: labels['youStartedWorking']!,
          time: workingSession.workStarted!,
        ),
        if (workingSession.stoppedWorking != null) ...[
          DisplayTimeView(
            label: labels['youStoppedWorking']!,
            time: workingSession.stoppedWorking!,
          ),
          TimeUsedView(
            label: youWorkedLabel,
            hoursLabel: hoursLabel,
            minutesLabel: minutesLabel,
            secondsLabel: secondsLabel,
            timeUsed: workingSession.workDuration!,
            andLabel: labels['and']!,
          )
        ]
      ],
    );
    // return Text(
    //     [
    //       '${labels['youStartedWorking']!}: ${dateFormat.format(workingSession.workStarted!)}. ',
    //       if (workingSession.stoppedWorking != null)
    //         '${labels['youStoppedWorking']!}: ${dateFormat.format(workingSession.stoppedWorking!)}. ',
    //       if (workingSession.stoppedWorking != null)
    //         '$youWorkedLabel ${workingSession.workDuration!.inHours} $hoursLabel ${workingSession.workDuration!.inMinutes} $minutesLabel, ${workingSession.workDuration!.inSeconds} $secondsLabel\n'
    //     ].join(),
    //     style: Theme.of(context).textTheme.titleLarge);
  }
}
