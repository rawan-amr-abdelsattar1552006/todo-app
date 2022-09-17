import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archeived_todos_screen.dart';
import 'package:todo/modules/done_todos_screen.dart';
import 'dart:ui';

import 'package:todo/modules/new_todos_screen.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit cubit = BlocProvider.of(context);

            return Scaffold(
                key: scaffoldKey,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  title: Text(
                    cubit.titles[cubit.currentIndex],
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      formKey.currentState?.validate();
                      if (cubit.isBottomSheetShown) {
                        if (formKey.currentState!.validate()) {
                          cubit.changeIsBottmSheetShown(false);
                          Navigator.pop(context);
                          cubit.changeFabIcon(Icons.edit);
                          cubit
                              .insertToDatabase(
                                  cubit.titleController.text,
                                  cubit.dateController.text,
                                  cubit.timeController.text,
                                  cubit.database)
                              .then((value) {
                            cubit.changeFabIcon(Icons.edit);
                            cubit.emptyTextFields();
                          });
                        }
                      } else {
                        cubit.changeIsBottmSheetShown(true);

                        cubit.changeFabIcon(Icons.add);
                        scaffoldKey.currentState!
                            .showBottomSheet((context) => MyBottomSheet(
                                formKey,
                                cubit.titleController,
                                cubit.dateController,
                                cubit.timeController,
                                context))
                            .closed
                            .then((value) {
                          cubit.changeIsBottmSheetShown(false);

                          cubit.getDataFromDatabase(cubit.database);
                          cubit.changeFabIcon(Icons.edit);
                          cubit.emptyTextFields();
                        });
                      }
                    },
                    child: Icon(cubit.fabIcon, color: Colors.white)),
                bottomNavigationBar: CurvedNavigationBar(
                    color: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    index: cubit.currentIndex,
                    onTap: (index) {
                      cubit.changeIndex(index);
                    },
                    backgroundColor: Colors.white,
                    items: [
                      Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.done_outlined,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.archive,
                        color: Colors.white,
                      )
                    ]),
                body: state is AppProgressIndicatorState
                    ? Center(child: CircularProgressIndicator())
                    : cubit.screens[cubit.currentIndex]);
          }),
    );
  }
}
