import 'package:intl/intl.dart';

void getEverything(dynamic jsonData) {
  final freeTime = FreeTime.fromJson(jsonData);
  freeTime.calculateFreeTime();
  freeTime.freeEvents.forEach((element) {
    print(element);
  });
}

class CutomEvent {
  DateTime start;
  DateTime end;
  CutomEvent(this.start, this.end);
  CutomEvent.fromJson(Map<String, dynamic> json) {
    start = DateTime.parse(json['start']);
    end = DateTime.parse(json['end']);
  }
}

class FreeTime {
  List<CutomEvent> events;
  List<DurationStructure> freeEvents;

  FreeTime.fromJson(Map<String, dynamic> json) {
    if (json['busy'] != null) {
      events = <CutomEvent>[];
      freeEvents = <DurationStructure>[];
      json['busy'].forEach((v) {
        events.add(CutomEvent.fromJson(v));
      });
    }
  }
  List<DurationStructure> filterByDuration(Duration duration) {
    return freeEvents.map((durationStructure) {
      if (durationStructure.duration >= duration) {
        return durationStructure;
      }
    }).toList();
  }

  void calculateFreeTime() {
    for (var i = 0; i < events.length - 1; i++) {
      final event = events.elementAt(i);
      final duration = events.elementAt(i + 1).start.difference(event.end);
      final start = event.end;
      final end = events.elementAt(i + 1).start;
      freeEvents.add(DurationStructure(duration, start, end));
    }
  }
}

class DurationStructure {
  Duration duration;
  DateTime start;
  DateTime end;
  DurationStructure(this.duration, this.start, this.end);
  String formatDuration() {
    var seconds = duration.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final tokens = <String>[];
    if (days != 0) {
      if (days == 1) {
        tokens.add('$days day');
      } else {
        tokens.add('$days days');
      }
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('$hours hours');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('$minutes minutes');
    }
    if (duration >= Duration(days: 1)) {
      return tokens[0];
    }
    return tokens.join(',');
  }

  String getTimeLine() {
    final startDate = DateFormat.MMMd().format(start);
    final endDate = DateFormat.MMMd().format(end);
    final time = DateFormat.jm().format(start);
    if (duration < Duration(days: 1)) {
      return 'On $startDate at $time for ${formatDuration()}';
    }
    return 'From $startDate to $endDate';
  }

  @override
  String toString() {
    final startDate = DateFormat.MMMd().format(start);
    final startTime = DateFormat.jm().format(start);
    final endDate = DateFormat.MMMd().format(end);
    final endTime = DateFormat.jm().format(end);

    return 'Total Time : $formatDuration(), Start Date : $startDate , Start Time : $startTime , End Date : $endDate , End Time : $endTime';
  }

  static String getTitle(Duration duration) {
    if (duration >= Duration.zero && duration < Duration(hours: 3)) {
      return 'You could take a small nap!';
    } else if (duration >= Duration(hours: 3) &&
        duration < Duration(hours: 10)) {
      return 'Go out and have fun. You earned that.';
    } else if (duration >= Duration(hours: 10) &&
        duration < Duration(hours: 23)) {
      return 'It\'s picnic time.';
    } else if (duration >= Duration(hours: 23) &&
        duration < Duration(days: 2, hours: 10)) {
      return 'It\'s picnic time.';
    } else if (duration >= Duration(days: 2, hours: 10) &&
        duration < Duration(days: 7)) {
      return 'It\'s vacation time';
    } else if (duration >= Duration(days: 7)) {
      return 'You are going places.';
    } else {
      return 'You got free time.';
    }
  }
}
