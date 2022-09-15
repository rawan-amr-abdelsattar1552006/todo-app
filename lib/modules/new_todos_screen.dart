import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/constants.dart';

import '../constants.dart';

class NewTodosScreen extends StatefulWidget {
  @override
  State<NewTodosScreen> createState() => _NewTodosScreenState();
}

class _NewTodosScreenState extends State<NewTodosScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(18)),
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      tasks[index]["date"],
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      tasks[index]["time"],
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  width: 180,
                  child: Text(
                    tasks[index]["title"],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: tasks.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 20,
          );
        },
      ),
    );
  }
}

WidgetItemSeperator() {
  return SizedBox(
    height: 20,
  );
}
