import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PeriodCalendar extends StatefulWidget {
  const PeriodCalendar({Key? key}) : super(key: key);

  @override
  State<PeriodCalendar> createState() => _PeriodCalendarState();
}

class _PeriodCalendarState extends State<PeriodCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  TextEditingController _cycleLengthController = TextEditingController();

  int daysLeft = 0;

  List<DateTime> _menstruationDates = []; // List of menstruation dates
  int get _cycleLength => int.tryParse(_cycleLengthController.text) ?? 28;
  bool _isTrackingPeriod = false;
  bool _isPeriodDateLogged = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = null;
    _isTrackingPeriod = false;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  void _addMenstruationDate(DateTime date) {
    if (_isTrackingPeriod) {
      setState(() {
        _menstruationDates.add(date);
        _isPeriodDateLogged = true;

        // Update daysLeft when period date is logged
        DateTime nextCycleStartDate = _getNextCycleStartDate();
        DateTime now = DateTime.now();
        daysLeft = nextCycleStartDate.difference(now).inDays;
      });
    }
  }

  void _removeMenstruationDate(DateTime date) {
    setState(() {
      _menstruationDates.remove(date);
      _selectedDate = null;
      _isPeriodDateLogged = false;
      daysLeft = 0;
    });
  }

  DateTime _getNextCycleStartDate() {
    if (_menstruationDates.isEmpty) {
      return _focusedDay.add(Duration(days: _cycleLength));
    } else {
      DateTime lastMenstruationDate = _menstruationDates.last;
      return lastMenstruationDate.add(Duration(days: _cycleLength));
    }
  }

  void _scheduleNotification(DateTime notificationDate) {
    // TODO: Implement notification scheduling
  }

  List<DateTime> _getMenstruationDaysInRange(DateTime start, DateTime end) {
    List<DateTime> menstruationDays = [];
    for (DateTime date in _menstruationDates) {
      if (date.isAfter(end)) break;
      if (date.isBefore(start)) continue;
      menstruationDays.add(date);
    }
    return menstruationDays;
  }

  @override
  Widget build(BuildContext context) {
    DateTime nextCycleStartDate = _getNextCycleStartDate();
    DateTime now = DateTime.now();
    double progress = daysLeft /
        (_cycleLength != null && _cycleLength != 0 ? _cycleLength : 28.0);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  height: 120,
                  width: 1920,
                  color: Colors.pink,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(50, 50, 0, 0),
                    child: Text(
                      'Tracker & Logger',
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 250.0, // set your desired width here
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.pink,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextField(
                        controller: _cycleLengthController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Cycle length (days)',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text('Note: Default Period Length is set to 28 days.',
                      style: TextStyle(fontSize: 12)),
                  const SizedBox(
                    height: 30,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                      ),
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 219, 151, 208)
                                    .withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: progress),
                            duration: Duration(milliseconds: 1000),
                            builder: (BuildContext context, double value,
                                Widget? child) {
                              return CircularProgressIndicator(
                                value: value,
                                strokeWidth: 15,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 211, 101, 187)),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 100, 50, 0),
                        child: Center(
                          child: Text("$daysLeft days left",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.pink)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2023),
                    lastDay: DateTime(2030),
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    selectedDayPredicate: (day) {
                      if (_selectedDate == null) {
                        return false;
                      }
                      return isSameDay(_selectedDate!, day);
                    },
                    onDaySelected: _onDaySelected,
                    availableGestures: AvailableGestures.none,
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      headerPadding: EdgeInsets.zero,
                      headerMargin: EdgeInsets.zero,
                    ),
                    calendarBuilders: CalendarBuilders(
                      todayBuilder: (context, day, _) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.pink, // Change the color to pink
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                      selectedBuilder: (context, day, _) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                      markerBuilder: (context, day, events) {
                        final isCycleStartDay =
                            _menstruationDates.contains(day);
                        final isCycleDay = _selectedDate != null &&
                            isSameDay(day, _selectedDate!);
                        final isHighlightedDay = _isPeriodDateLogged &&
                            (isCycleStartDay ||
                                isCycleDay ||
                                (nextCycleStartDate.difference(day).inDays <=
                                        3 &&
                                    nextCycleStartDate.difference(day).inDays >=
                                        0));
                        if (isHighlightedDay) {
                          return Positioned(
                            bottom: 5,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.pink,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isTrackingPeriod = true;
                          });
                          _addMenstruationDate(_selectedDate!);
                        },
                        child: Text(
                          "Log Period Date",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            _removeMenstruationDate(_selectedDate!),
                        child: Text(
                          "Remove Period Date",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                      "Next cycle starts on: ${nextCycleStartDate.toString().substring(0, 10)}"),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _scheduleNotification(nextCycleStartDate),
                    child: Text(
                      "Set Reminder",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 2);
    path.cubicTo(size.width / 4, 3 * (size.height / 2), 3 * (size.width / 4),
        size.height / 2, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
