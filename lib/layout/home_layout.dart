import 'package:intl/intl.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archeived_todos_screen.dart';
import 'package:todo/modules/done_todos_screen.dart';
import 'dart:ui';

import 'package:todo/modules/new_todos_screen.dart';

import '../constants.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  bool update = false;
  late Database database;

  int listItemsCount = 0;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var fabIcon = Icons.edit;
  var mytasks = ValueNotifier(tasks);

  List<String> titles = ["New Todos", "Done Todos", "Archeived Todos"];
  bool isBottomSheetShown = false;
  void createDatabase() async {
    database =
        await openDatabase('todo.db', version: 1, onCreate: (db, version) {
      print("Database created");
      db
          .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {})
          .catchError((error) {
        print(" caught this error : $error");
      });
    }, onOpen: (db) {
      getDataFromDatabase(db).then((value) => setState(() {
            tasks = value;
          }));

      print("Database opened");
    });
  }

  Future<List<Map>> getDataFromDatabase(Database database) async {
    return await database.rawQuery("SELECT * FROM Tasks");
  }

  Future insertToDatabase(String title, String date, String time) async {
    return await database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO Tasks(title, date, time, status) VALUES("$title", "$date", "$time","New") ')
            .then((value) {
          print("$value inserted successfully");
        }).catchError((error) {
          print(" caught this error : $error");
        }));
  }

  @override
  void initState() {
    super.initState;

    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      NewTodosScreen(),
      DoneTodosScreen(),
      ArcheivedTodosScreen()
    ];

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0.0,
        title: Text(titles[currentIndex]),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            formKey.currentState?.validate();
            if (isBottomSheetShown) {
              if (formKey.currentState!.validate()) {
                isBottomSheetShown = false;
                Navigator.pop(context);
                setState(() {
                  fabIcon = Icons.edit;
                  insertToDatabase(titleController.text, dateController.text,
                      timeController.text).then((value) =>  getDataFromDatabase(database).then((value) => setState(() {
                          tasks = value;
                          fabIcon = Icons.edit;
                          titleController.text = "";
                          dateController.text = "";
                          timeController.text = "";
                        })););

                  titleController.text = "";
                  dateController.text = "";
                  timeController.text = "";
                });
              }
            } else {
              isBottomSheetShown = true;
              setState(() {
                fabIcon = Icons.add;
                scaffoldKey.currentState!
                    .showBottomSheet((context) => MyBottomSheet())
                    .closed
                    .then((value) {
                  isBottomSheetShown = false;

                  setState(() {
                    getDataFromDatabase(database).then((value) => setState(() {
                          tasks = value;
                          fabIcon = Icons.edit;
                          titleController.text = "";
                          dateController.text = "";
                          timeController.text = "";
                        }));
                  });
                });
              });
            }
          },
          child: Icon(fabIcon, color: Colors.indigo)),
      bottomNavigationBar: CurvedNavigationBar(
          animationDuration: Duration(milliseconds: 300),
          index: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          backgroundColor: Colors.indigo,
          items: [
            Icon(
              Icons.task,
              color: Colors.indigo,
            ),
            Icon(
              Icons.done,
              color: Colors.indigo,
            ),
            Icon(
              Icons.archive,
              color: Colors.indigo,
            )
          ]),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: screens[currentIndex],
      ),
    );
  }

  Widget MyBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Column(children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Task Title",
                        prefixIcon: Icon(Icons.title),
                      ),
                      controller: titleController,
                      validator: (v) {
                        if (v != null && v.isEmpty) {
                          return 'task title cannot be empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Task Date",
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2026, 1, 1))
                            .then((value) => dateController.text =
                                DateFormat.yMMMd().format(value!));
                      },
                      controller: dateController,
                      validator: (v) {
                        if (v != null && v.isEmpty) {
                          return 'task date cannot be empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                          labelText: "Task Time",
                          prefixIcon: Icon(Icons.watch_later),
                        ),
                        controller: timeController,
                        validator: (v) {
                          if (v != null && v.isEmpty) {
                            return 'task time cannot be empty';
                          }
                          return null;
                        },
                        onTap: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) => timeController.text =
                                  value!.format(context).toString());
                        })
                  ]))
            ],
          ),
        ),
      ],
    );
  }
}
