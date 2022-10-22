import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/models/db_helper.dart';
import 'package:todo_app/screens/note_screen.dart';
import 'package:todo_app/utils/constants.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key});

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  DBHelper dbHelper = DBHelper();

  List notes = [];
  List scheduledTasks = [];
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool isLoading = false;
  getNotes() async {
    List response = await dbHelper.getNotes();

    notes.addAll(response);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          calendarFormat: CalendarFormat.month,
          locale: 'en_US',
          weekendDays: const [5, 6],
          startingDayOfWeek: StartingDayOfWeek.saturday,
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2022, 1, 1),
          lastDay: DateTime.utc(2028, 1, 1),
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: const CalendarStyle(
            // rowDecoration: const BoxDecoration(color: Colors.transparent),
            defaultTextStyle: TextStyle(
              color: Colors.white,
            ),
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff3C1F7B),
            ),
          ),
          currentDay: _selectedDay,
          onDaySelected: (selectedDay, focusedDay) async {
            setState(() {
              _selectedDay = selectedDay;
            });
            scheduledTasks.clear();
            setState(() {
              scheduledTasks.addAll(notes.where((element) =>
                  element['date'] ==
                  DateFormat('EEEE.d MMMM yyyy')
                      .format(selectedDay)
                      .toString()));
            });
          },
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekendStyle: TextStyle(color: Colors.red),
            weekdayStyle: TextStyle(color: Colors.white),
          ),
          headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(color: Colors.white),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.white,
              )),
        ),
        const SizedBox(
          height: 15,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Scheduled',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: scheduledTasks.isEmpty ? 193 : getWidth(context),
          height: scheduledTasks.isEmpty ? 36 : 250,
          child: scheduledTasks.isEmpty
              ? Container(
                  width: 193,
                  height: 36,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xff3C1F7B)),
                  child: const Center(
                    child: Text(
                      'You have no scheduled Tasks',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ))
              : ListView.builder(
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.of(context)
                        .pushNamed(NoteScreen.routeName, arguments: {
                      'note': scheduledTasks[index]['note'],
                      'title': scheduledTasks[index]['title'],
                      'date': scheduledTasks[index]['date'],
                      'time': scheduledTasks[index]['time'],
                      'id': scheduledTasks[index]['id']
                    }),
                    onLongPress: () async {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete Note'),
                          content:
                              const Text('Do you want to delete the note?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await dbHelper.delete(
                                    "id= ${scheduledTasks[index]['id']}");
                                setState(() {
                                  scheduledTasks.removeWhere((element) =>
                                      element['id'] ==
                                      scheduledTasks[index]['id']);
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: getWidth(context) * .9,
                      height: getHeight(context) * .15,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff3C1F7B)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              scheduledTasks[index]['title'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text(
                            scheduledTasks[index]['note'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          scheduledTasks[index]['date'] == null
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    Text(
                                      scheduledTasks[index]['date'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      scheduledTasks[index]['time'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                  itemCount: scheduledTasks.length,
                ),
        ),
      ],
    );
  }
}
