import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:vacy/bottom_sheet.dart';
import 'package:vacy/color.dart';
import 'package:vacy/inherit.dart';
import 'models.dart';

ValueNotifier<bool> loading = ValueNotifier(false);
ValueNotifier<List<DurationStructure>> resultData = ValueNotifier([]);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  var currentSelectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ValueListenableBuilder<bool>(
            valueListenable: loading,
            builder: (context, value, child) {
              return AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation animation) =>
                      ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                  child: loading.value
                      ? SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 5.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : FuckedUpButton());
            }),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text('Vacy Vacy',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
        body: ValueListenableBuilder<List<DurationStructure>>(
          valueListenable: resultData,
          builder: (context, value, _) {
            if (value?.length == 0) {
              return Center(
                  child: Container(
                child: Text('Oops! theres nothing here'),
              ));
            }
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (BuildContext context, int index) {
                var result = value[index];
                return EventTile(
                    durationStructure: result,
                    lightShade: getColor(index)[0],
                    darkShade: getColor(index)[1]);
              },
            );
          },
        ));
  }
}

class FuckedUpButton extends StatelessWidget {
  const FuckedUpButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(85),
        ),
        onPressed: () {
          timeSelector(context);
        },
        child: Text(
          'M F**ked Up',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  final Color darkShade;
  final Color lightShade;
  final DurationStructure durationStructure;

  const EventTile(
      {Key key,
      @required this.darkShade,
      @required this.lightShade,
      this.durationStructure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: kIsWeb ? 140 : MediaQuery.of(context).size.height * 0.17,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              stops: [0.02, 0.02], colors: [darkShade, lightShade]),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                          DurationStructure.getTitle(
                              durationStructure.duration),
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(durationStructure.getTimeLine(),
                          style: Theme.of(context).textTheme.caption),
                    ),
                    if (durationStructure.duration >= Duration(days: 1))
                      Flexible(
                        flex: 2,
                        child: Text(
                            'You have got ${durationStructure.formatDuration()}',
                            style: Theme.of(context).textTheme.caption),
                      )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.pan_tool_outlined),
                      onPressed: () {
                        TextEditingController _controller =
                            TextEditingController();
                        var _startTime = durationStructure.start;
                        var _endTime = durationStructure.end;
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actions: [
                                  ElevatedButton(
                                    child: Text('Done'),
                                    onPressed: () async {
                                      final val =
                                          await CalendarClientInherited.of(
                                                  context)
                                              .calendarClient
                                              .addEvent(_controller.text,
                                                  _startTime, _endTime);

                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: val
                                            ? Text(
                                                'Event added in google calendar')
                                            : Text(
                                                'Unable to add event in google calendar'),
                                      ));
                                    },
                                  )
                                ],
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Title',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      TitleTextField(
                                        controller: _controller,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'End Of The Time',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300],
                                                width: 0.5)),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        child: CupertinoDatePicker(
                                          onDateTimeChanged: (DateTime val) {
                                            _startTime = val;
                                          },
                                          use24hFormat: true,
                                          initialDateTime: _startTime,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'End Of The Time',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300],
                                                width: 0.5)),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        child: CupertinoDatePicker(
                                          onDateTimeChanged: (DateTime val) {
                                            _endTime = val;
                                          },
                                          use24hFormat: true,
                                          initialDateTime: _endTime,
                                        ),
                                      ),
                                    ]),
                              );
                            });
                      }),
                  Text(
                    'This  is It!',
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

void timeSelector(BuildContext context) async {
  List<DurationStructure> result = await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: AddPartyModal(),
        );
      });
  loading.value = false;
  result ??= [];
  resultData.value = result;
}

class TitleTextField extends StatelessWidget {
  final TextEditingController controller;
  const TitleTextField({Key key, this.controller})
      : assert(controller != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
          controller: controller,
          onSaved: (s) {},
          decoration: InputDecoration.collapsed(hintText: 'Title')),
    );
  }
}
