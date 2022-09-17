import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class NewTodosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = BlocProvider.of(context);

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => cubit.NewTodos.length < 1
            ? Center(
                child: Container(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No New Todos Yet ,",
                          style: TextStyle(fontSize: 20)),
                      Text("Add Some...", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                    bottom: 50, top: 30, right: 20, left: 10),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 10),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      child: Row(children: [
                        IconButton(
                          onPressed: () {
                            cubit.UpdateData(
                                'Done', cubit.NewTodos[index]['id']);
                          },
                          icon: Icon(Icons.check_circle_outline_rounded,
                              size: 28),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Text(
                                cubit.NewTodos[index]["title"],
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.w500),
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
                                    cubit.NewTodos[index]["date"],
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  SizedBox(width: 11),
                                  Icon(Icons.watch_later, size: 20),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    cubit.NewTodos[index]["time"],
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.delete_outlined,
                                color: Colors.black),
                            onPressed: () {
                              cubit.UpdateData(
                                  'Archeived', cubit.NewTodos[index]['id']);
                            })
                      ]),
                    );
                  },
                  itemCount: cubit.NewTodos.length,
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
                              cubit.NewTodos[index]["date"],
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              cubit.NewTodos[index]["time"],
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
                            cubit.NewTodos[index]["title"],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
*/