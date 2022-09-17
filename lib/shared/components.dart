import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget MyBottomSheet(
    formKey, titleController, dateController, timeController, context) {
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
                                context: context, initialTime: TimeOfDay.now())
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
