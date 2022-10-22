import 'package:flutter/material.dart';
import 'package:todo_app/screens/log_in_screen.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/note_screen.dart';
import 'package:todo_app/screens/schedule_screen.dart';
import 'package:todo_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        LogInScreen.routeName: (context) => const LogInScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        ScheduleScreen.routeName: (context) => const ScheduleScreen(),
        NoteScreen.routeName: (context) => const NoteScreen(),
      },
    );
  }
}
