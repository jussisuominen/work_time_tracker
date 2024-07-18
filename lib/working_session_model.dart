import 'package:work_time_tracker/logger.dart';

class WorkingSessionModel {
  DateTime? workStarted; // Datetime when user started working.
  DateTime? stoppedWorking; // Datetime when user stopped working.
  Duration? workDuration;

  WorkingSessionModel();

  WorkingSessionModel.fromJson(Map<String, dynamic> json) {
    workStarted = DateTime.parse(json['workStarted']);
    stoppedWorking = DateTime.parse(json['stoppedWorking']);

    String durationData = json['workDuration'];
    List<String> splittedDurationData = durationData.split(':');
    logger.d(splittedDurationData);

    int hours = int.parse(splittedDurationData[0]);
    int minutes = int.parse(splittedDurationData[1]);

    String secondsData = splittedDurationData[2].split('.')[0];

    int seconds = int.parse(secondsData);

    logger.d('Hours: $hours. Minutes: $minutes. Seconds: $seconds');

    workDuration = Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  // : workStarted = DateTime.parse(json['workStarted']),
  //   stoppedWorking = DateTime.parse(json['stoppedWorking']),
  //   workDuration = json['workDuration'] as Duration?;

  Map<String, dynamic> toJson() {
    return {
      'workStarted': workStarted?.toIso8601String(),
      'stoppedWorking': stoppedWorking?.toIso8601String(),
      'workDuration': workDuration?.toString()
    };
  }

  @override
  String toString() {
    return '''Work started: ${workStarted.toString()}
      Work stopped: ${stoppedWorking.toString()}
      Time used: ${workDuration.toString()}
      ''';
  }
}
