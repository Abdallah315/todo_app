import 'package:flutter/material.dart';
import 'package:todo_app/models/db_helper.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/utils/constants.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});
  static const routeName = '/note-screen';
  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DBHelper dbHelper = DBHelper();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    titleController.text = args != null ? args['title'] : titleController.text;
    noteController.text = args != null ? args['note'] : noteController.text;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: getWidth(context),
          height: getHeight(context),
          padding: const EdgeInsets.all(10),
          color: const Color(0xff7E64FF),
          child: Column(
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
                        if (args == null) {
                          await dbHelper.insert(values: {
                            'note': noteController.text,
                            'title': titleController.text,
                          });
                          print('success ==============>');
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomeScreen.routeName, (route) => false);
                        } else {
                          await dbHelper.update({
                            'note': noteController.text,
                            'title': titleController.text,
                          }, "id= ${args['id']}");
                          print('success');
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomeScreen.routeName, (route) => false);
                        }
                      }),
                ],
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        onSaved: (newValue) {
                          formKey.currentState!.save();
                          titleController.text = newValue!;
                        },
                        onChanged: (value) {
                          if (args != null) {
                            args['title'] = value;
                          }
                        },
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Title',
                            hintStyle: TextStyle(color: Colors.white)),
                      ),
                      TextFormField(
                        controller: noteController,
                        onSaved: (newValue) {
                          formKey.currentState!.save();
                          noteController.text = newValue!;
                        },
                        onChanged: (value) {
                          if (args != null) {
                            args['note'] = value;
                          }
                        },
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Your Note',
                            hintStyle: TextStyle(color: Colors.white)),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
