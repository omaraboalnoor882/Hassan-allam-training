import 'package:bloc/bloc.dart';
import 'package:course_training/Shared/cubit/states.dart';
import 'package:course_training/Shared/network/remote/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../Modules/todoApp/archived_tasks/archived_tasks_screen.dart';
import '../../Modules/todoApp/done_tasks/done_tasks_screen.dart';
import '../../Modules/todoApp/new_tasks/new_tasks_screen.dart';
import '../Components/Constants.dart';
import '../network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  bool isDark = false;
  ThemeMode appMode = ThemeMode.dark;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];

  void createDatabase() {
     openDatabase(
      'todo.db',//Always put db because it creates a file
      version: 1, //means one table
      onCreate: (database, version){

        // id integar
        // title String
        // date String
        // time String
        //status string

        print('database created');
        database.execute('CREATE TABLE tasks (id INTEGAR PRIMARY KEY, title TEXT, date TIME, time TEXT, status TEXT)').then((error){
          print('table created');//It returns future void, so we to make it await
        }).catchError((error){
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database){
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
     });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async{
    await database.transaction((txn) async{
      txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error){
        print('Error When Inserting New Record ${error.toString()}');
      });//عشان انا هروح اودي data
      return null;
    });
  }


  void getDataFromDatabase(database){

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value){


      value.forEach((element) {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });

      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
}) async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ?, WHERE id = ?',
        ['$status', '$id'],
    ).then((value){
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', ['id'])
    .then((value){
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
}){
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

  void changeAppMode({bool? fromShared}){ //'required' is add
    if(fromShared != null){
      emit(AppChangeModeState());
      isDark = fromShared;
    }

    else{
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value){
        emit(AppChangeModeState());
      });
    }
  }

}