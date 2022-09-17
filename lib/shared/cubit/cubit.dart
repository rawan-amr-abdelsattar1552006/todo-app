import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/modules/archeived_todos_screen.dart';
import 'package:todo/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import '../../modules/done_todos_screen.dart';
import '../../modules/new_todos_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  List<Map> tasks = [];
  bool isBottomSheetShown = false;
  int currentIndex = 0;
  List<String> titles = ["New Todos", "Done Todos", "Archeived Todos"];
  var fabIcon = Icons.edit;
  List<Widget> screens = [
    NewTodosScreen(),
    DoneTodosScreen(),
    ArcheivedTodosScreen()
  ];
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  late Database database;

  List<Map> NewTodos = [];
  List<Map> DoneTodos = [];
  List<Map> ArcheivedTodos = [];

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBar());
  }

  void changeIsBottmSheetShown(bool value) {
    isBottomSheetShown = value;
    emit(AppChangeIsBottomSheetShownState());
  }

  void changeFabIcon(IconData icon) {
    fabIcon = icon;
    emit(AppChangeFabIcon());
  }

  void emptyTextFields() {
    titleController.text = "";
    dateController.text = "";
    timeController.text = "";
    emit(AppEmptyTextFieldsState());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (db, version) {
      print("Database created");
      db
          .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {})
          .catchError((error) {
        print(" caught this error : $error");
      });
    }, onOpen: (db) {
      getDataFromDatabase(db);

      print("Database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void deleteTask(id) {
    database.transaction((txn) =>
        txn.rawUpdate(' DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
          emit(AppDeleteDatabaseState());
          getDataFromDatabase(database);
          print("deleted $value");
        }));
  }

  void UpdateData(status, id) {
    database.transaction((txn) => txn.rawUpdate(
            'UPDATE Tasks SET status = ? WHERE id = ?',
            [status, id]).then((value) {
          emit(AppUpdateDatabaseState());
          getDataFromDatabase(database);
          print("updated $value");
        }));
  }

  /* List<List<Map>> returnAllTodos() {
    return [NewTodos, DoneTodos, ArcheivedTodos];
    emit(AppReturnAllTodosState());
  }*/

  void getDataFromDatabase(Database database) {
    emit(AppProgressIndicatorState());
    database.rawQuery("SELECT * FROM Tasks").then((value) {
      tasks = value;
      NewTodos = [];
      ArcheivedTodos = [];
      DoneTodos = [];
      emit(AppGetDataFromDatabaseState());
      tasks.forEach((task) {
        if (task['status'] == 'New') {
          NewTodos.add(task);
        } else if (task['status'] == 'Done') {
          DoneTodos.add(task);
        } else {
          ArcheivedTodos.add(task);
        }
      });

      //returnAllTodos();
    });
    ;
  }

  insertToDatabase(String title, String date, String time, Database database) {
    return database
        .transaction((txn) => txn
                .rawInsert(
                    'INSERT INTO Tasks(title, date, time, status) VALUES("$title", "$date", "$time","New") ')
                .then((value) {
              print("$value inserted successfully");
            }).catchError((error) {
              print(" caught this error : $error");
            }))
        .then((value) {
      emit(AppInsertDataToDatabaseState());
      this.getDataFromDatabase(database);
    });
  }
}
