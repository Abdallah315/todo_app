import 'package:flutter/material.dart';
import 'package:todo_app/models/db_helper.dart';
import 'package:todo_app/screens/note_screen.dart';
import 'package:todo_app/utils/constants.dart';

class NotesWidget extends StatefulWidget {
  const NotesWidget({super.key});

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  DBHelper dbHelper = DBHelper();

  List notes = [];
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
    return Expanded(
      child: SizedBox(
        width: getWidth(context),
        child: isLoading == true
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemBuilder: (context, index) => InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed(NoteScreen.routeName, arguments: {
                    'note': notes[index]['note'],
                    'title': notes[index]['title'],
                    'date': notes[index]['date'],
                    'time': notes[index]['time'],
                    'id': notes[index]['id']
                  }),
                  onLongPress: () async {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Delete Note'),
                        content: const Text('Do you want to delete the note?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await dbHelper
                                  .delete("id= ${notes[index]['id']}");
                              setState(() {
                                notes.removeWhere((element) =>
                                    element['id'] == notes[index]['id']);
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xff7E64FF)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            notes[index]['title'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          notes[index]['note'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        notes[index]['date'] == null
                            ? const SizedBox()
                            : Row(
                                children: [
                                  Text(
                                    notes[index]['date'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    notes[index]['time'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                itemCount: notes.length,
              ),
      ),
    );
  }
}
