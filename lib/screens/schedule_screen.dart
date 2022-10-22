import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/db_helper.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/utils/constants.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  static const routeName = '/schedule-screen';

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController noteController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  late DBHelper dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: getWidth(context),
          height: getHeight(context),
          padding: const EdgeInsets.all(10),
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
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    color: Colors.white,
                    onPressed: () async {
                      await dbHelper.insert(values: {
                        'note': noteController.text,
                        'date': DateFormat('EEEE.d MMMM yyyy')
                            .format(selectedDate)
                            .toString(),
                        'title': titleController.text,
                        'time': selectedTime.format(context).toString(),
                      });
                      setState(() {});
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Schedule',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 35,
              ),
              SizedBox(
                height: 40,
                child: TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must fill out the required data';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      filled: true,
                      fillColor: const Color(0xffCCC2FE),
                      hintText: 'Title'),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Date',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  GestureDetector(
                    onTap: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.utc(2022, 10, DateTime.now().day),
                      firstDate: DateTime.utc(2022, 10, DateTime.now().day),
                      lastDate: DateTime.utc(2030, 10, 30),
                    ).then((value) => setState(() => selectedDate = value!)),
                    child: Row(
                      children: [
                        Text(
                          DateFormat('EEEE.d MMMM yyyy')
                              .format(selectedDate)
                              .toString(),
                          style: TextStyle(color: Colors.grey.withOpacity(.7)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Colors.grey.withOpacity(.7),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Time',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  GestureDetector(
                    onTap: () => showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) => setState(() => selectedTime = value!)),
                    child: Row(
                      children: [
                        Text(
                          selectedTime.format(context),
                          style: TextStyle(color: Colors.grey.withOpacity(.7)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Colors.grey.withOpacity(.7),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              SizedBox(
                height: 40,
                child: TextFormField(
                  controller: noteController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must fill out the required data';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      filled: true,
                      fillColor: const Color(0xffCCC2FE),
                      hintText: 'Note'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
