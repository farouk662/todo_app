
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';

import '../screens/archived_tasks.dart';
import '../screens/done_tasks.dart';
import '../screens/new_tasks.dart';


class AppCubit extends Cubit<AppStates> {
  int currentIndex = 0;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> screens = [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  late Database database;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('created');
      database
          .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT,time TEXT, status TEXT )')
          .then((value) {
        print('table creted');
      }).catchError((onError) {
        print('error');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('Opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertIntoDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('${value.toString()} inserted successfully');
        emit(AppInsertIntoDataState());
        getDataFromDatabase(database);
      }).catchError((onError) {
        print('error occurred {$onError.toString()}');
      });
      return Future(() => null);
    });
  }

  void getDataFromDatabase(database) {
    newTasks.clear();
    doneTasks.clear();
    archivedTasks.clear();
    emit(AppLoadingState());
    List<Map> tasks;
    database.rawQuery("SELECT * FROM tasks").then((value) {
      tasks = value;
      emit(AppGetDatabaseState());
      for (var element in tasks) {
        print(element['status']);
        switch (element['status']) {
          case 'new':
            newTasks.add(element);
            break;
          case 'archived':
            archivedTasks.add(element);
            break;
          case 'done':
            doneTasks.add(element);
        }
      }
    });
  }

  void updateData({required String status, required int id}) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });

  }
  void deleteData({required int id}) async {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]).then((value) {

          // getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });

  }

  void changeBottomSheetState({required bool isShown, required IconData icon}) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
