import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:todo_app/screens/note_screen.dart';
import 'package:todo_app/screens/schedule_screen.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/widgets/notes_widget.dart';
import 'package:todo_app/widgets/schedule_widget.dart';

enum SwitchScreen { schedule, note }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenScreenState();
}

class _HomeScreenScreenState extends State<HomeScreen> {
  SwitchScreen _switchScreen = SwitchScreen.schedule;
  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      overlayColor: Colors.black.withOpacity(.7),
      useRotationAnimation: true,
      backgroundColor: const Color(0xff7E64FF),
      visible: true,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.calendar_month, color: Colors.white),
          backgroundColor: const Color(0xff7E64FF),
          onTap: () =>
              Navigator.of(context).pushNamed(ScheduleScreen.routeName),
          label: 'Schedule',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: const Icon(Icons.note, color: Colors.white),
          backgroundColor: const Color(0xff7E64FF),
          foregroundColor: Colors.black,
          elevation: 0,
          onTap: () => Navigator.of(context).pushNamed(NoteScreen.routeName),
          label: 'Note',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: buildSpeedDial(),
        body: Container(
          padding: const EdgeInsets.all(10),
          width: getWidth(context),
          height: getHeight(context),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff2A2A2E),
                Color(0xff1F1338),
                Color(0xff1F1338),
                Color(0xff000000)
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              width: getWidth(context),
              height: getHeight(context),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'on.time',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 24,
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2, color: const Color(0xff3C1F7B))),
                    width: 270,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 133,
                          height: 32,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xff272430),
                                backgroundColor:
                                    _switchScreen == SwitchScreen.schedule
                                        ? const Color(0xff272430)
                                        : const Color(0xff3C1F7B)),
                            onPressed: () {
                              setState(() {
                                _switchScreen = SwitchScreen.schedule;
                              });
                            },
                            child: const Center(
                              child: Text(
                                'Schedule',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 133,
                          height: 32,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xff272430),
                                backgroundColor:
                                    _switchScreen == SwitchScreen.note
                                        ? const Color(0xff272430)
                                        : const Color(0xff3C1F7B)),
                            onPressed: () {
                              setState(() {
                                _switchScreen = SwitchScreen.note;
                              });
                            },
                            child: const Center(
                              child: Text(
                                'Note',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  _switchScreen == SwitchScreen.schedule
                      ? const ScheduleWidget()
                      : const NotesWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
