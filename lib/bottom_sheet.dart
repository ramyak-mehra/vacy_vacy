import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:vacy/home.dart';
import 'package:vacy/inherit.dart';
import 'package:vacy/models.dart';

class AddPartyModal extends StatefulWidget {
  @override
  _AddPartyModalState createState() => _AddPartyModalState();
}

class _AddPartyModalState extends State<AddPartyModal> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(Duration(hours: 1));
  final TextEditingController _descriptionController = TextEditingController();
  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  var currentSelectedValue;
  int days = 0;
  int hours = 0;
  int minutes = 0;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Size _size;
    if (deviceSize.height > 900) {
      _size = Size(900 / 2.1, 900);
    } else {
      _size = Size(deviceSize.height / 2.1, deviceSize.height);
    }
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: _size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                      height: _size.height * 0.0075,
                      width: _size.width * 0.12,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Select Time Period',
                      style: textTheme.bodyText1,
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          NumberPicker(
                            selectedTextStyle: textTheme.headline5
                                .copyWith(color: Colors.green),
                            itemHeight: 30,
                            infiniteLoop: true,
                            value: days,
                            maxValue: 100,
                            minValue: 0,
                            onChanged: (int value) {
                              setState(() {
                                days = value;
                              });
                            },
                          ),
                          Text(
                            'days',
                            style:
                                textTheme.headline6.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          NumberPicker(
                            selectedTextStyle: textTheme.headline5
                                .copyWith(color: Colors.green),
                            itemHeight: 30,
                            infiniteLoop: true,
                            value: hours,
                            maxValue: 59,
                            minValue: 0,
                            onChanged: (int value) {
                              setState(() {
                                hours = value;
                              });
                            },
                          ),
                          Text(
                            'hours',
                            style:
                                textTheme.headline6.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          NumberPicker(
                            selectedTextStyle: textTheme.headline5
                                .copyWith(color: Colors.green),
                            itemHeight: 30,
                            infiniteLoop: true,
                            value: minutes,
                            maxValue: 60,
                            minValue: 0,
                            onChanged: (int value) {
                              setState(() {
                                minutes = value;
                              });
                            },
                          ),
                          Text(
                            'minutes',
                            style:
                                textTheme.headline6.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Start Of The Time',
                        style: textTheme.headline6.copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey[300], width: 0.5)),
                    height: _size.height * 0.15,
                    child: CupertinoDatePicker(
                      onDateTimeChanged: (DateTime val) {
                        _startTime = val;
                      },
                      use24hFormat: true,
                      initialDateTime: _startTime,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'End Of The Time',
                        style: textTheme.headline6.copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey[300], width: 0.5)),
                    height: _size.height * 0.15,
                    child: CupertinoDatePicker(
                      onDateTimeChanged: (DateTime val) {
                        _endTime = val;
                      },
                      use24hFormat: true,
                      initialDateTime: _endTime,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  HostPartyButton(
                    onTap: () async {
                      Duration duration =
                          Duration(days: days, hours: hours, minutes: minutes);
                      loading.value = true;
                      final result = await _initialise(
                          context: context,
                          duration: duration,
                          startTime: _startTime.toUtc().toIso8601String(),
                          endTime: _endTime.toUtc().toIso8601String());
                      Navigator.pop(context, result);
                    },
                    text: 'Done!',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HostPartyButton extends StatelessWidget {
  final Function onTap;
  final String text;
  const HostPartyButton({
    Key key,
    @required this.text,
    this.onTap,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
          child: Text(text),
        ),
      ),
    );
  }
}

Future<List<DurationStructure>> _initialise(
    {BuildContext context,
    String startTime,
    String endTime,
    Duration duration}) async {
  final jsonData = await CalendarClientInherited.of(context)
      .calendarClient
      .getFreeData(startTime, endTime);
  final freeTime = FreeTime.fromJson(jsonData);
  freeTime.calculateFreeTime();
  var result = freeTime.filterByDuration(duration);
  result.removeWhere((element) => element == null);
  return result;
}
