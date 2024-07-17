import 'package:flutter/material.dart';
import 'package:work_time_tracker/date_format.dart';
import 'package:work_time_tracker/widgets/bold_text.dart';
import 'package:work_time_tracker/widgets/info_text.dart';

class DisplayTimeView extends StatelessWidget {
  final String label;
  final DateTime time;

  const DisplayTimeView({super.key, required this.label, required this.time});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        InfoText(
          text: '$label: ',
        ),
        BoldText(
          text: dateFormat.format(time),
        ),
        const InfoText(text: '. '),
      ],
    );
  }
}
