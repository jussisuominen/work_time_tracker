import 'package:flutter/material.dart';
import 'package:work_time_tracker/widgets/bold_text.dart';
import 'package:work_time_tracker/widgets/info_text.dart';

class TimeUsedView extends StatelessWidget {
  final String label;
  final Duration timeUsed;
  final String hoursLabel;
  final String minutesLabel;
  final String secondsLabel;
  final String andLabel;

  const TimeUsedView(
      {super.key,
      required this.label,
      required this.timeUsed,
      required this.hoursLabel,
      required this.minutesLabel,
      required this.secondsLabel,
      required this.andLabel});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      InfoText(
        text: '$label ',
      ),
      BoldText(
        text: timeUsed.inHours.toString(),
      ),
      InfoText(
        text: ' $hoursLabel',
      ),
      const InfoText(text: ', '),
      BoldText(
        text: '${timeUsed.inMinutes % 60}',
      ),
      InfoText(
        text: ' $minutesLabel',
      ),
      InfoText(text: ' $andLabel '),
      BoldText(
        text: '${timeUsed.inSeconds % 60}',
      ),
      InfoText(
        text: ' $secondsLabel',
      ),
      const InfoText(text: '.'),
    ]);
  }
}
