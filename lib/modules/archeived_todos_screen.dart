import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class ArcheivedTodosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = BlocProvider.of(context);

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => cubit.ArcheivedTodos.length < 1
            ? Center(
                child: Container(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No Archeived Todos Yet ,",
                          style: TextStyle(fontSize: 20)),
                      Text("Archeive Some...", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                    bottom: 50, top: 30, right: 20, left: 10),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Dismissible(
                      background: Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("Delete permanently",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                        ),
                        color: Colors.red,
                      ),
                      secondaryBackground: Container(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("Unarcheive",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                        ),
                        color: Colors.green,
                      ),
                      key: Key(cubit.ArcheivedTodos[index]['id'].toString()),
                      onDismissed: (direction) {
                        direction == DismissDirection.startToEnd
                            ? cubit
                                .deleteTask(cubit.ArcheivedTodos[index]['id'])
                            : cubit.UpdateData(
                                'New', cubit.ArcheivedTodos[index]['id']);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        width: double.infinity,
                        padding: const EdgeInsets.all(10.0),
                        child: Row(children: [
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: Text(
                                  cubit.ArcheivedTodos[index]["title"],
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500),
                                )),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month, size: 20),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      cubit.ArcheivedTodos[index]["date"],
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                    SizedBox(
                                      width: 11,
                                    ),
                                    Icon(Icons.watch_later, size: 20),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      cubit.ArcheivedTodos[index]["time"],
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                  itemCount: cubit.ArcheivedTodos.length,
                  separatorBuilder: (context, index) => WidgetItemSeperator(),
                ),
              ));
  }
}

WidgetItemSeperator() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    width: double.infinity,
    height: 1,
    color: Colors.grey[200],
  );
}

/*
Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18)),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              cubit.ArcheivedTodos[index]["date"],
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              cubit.ArcheivedTodos[index]["time"],
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Container(
                          width: 180,
                          child: Text(
                            cubit.ArcheivedTodos[index]["title"],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
*/