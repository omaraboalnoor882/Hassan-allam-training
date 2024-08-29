import 'package:course_training/Shared/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:course_training/Shared/Components/components.dart';


import '../../Shared/Components/Constants.dart';
import '../../Shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {




  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  //tasks.isNotEmpty?screens[currentIndex]:Center(child: const CircularProgressIndicator())//if tasks is empty , perform the loading thingy



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state){
          if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);
            }
        },
        builder: (BuildContext context, AppStates state){

          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                  cubit.titles[cubit.currentIndex]
              ),
            ),
            body:  cubit.screens[cubit.currentIndex], //if tasks is empty , perform the loading thingy
            floatingActionButton: FloatingActionButton(
              onPressed: ()//بيخليها تستنى شويه
              {
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertToDatabase(title: titleController.text, time: timeController.text, date: dateController.text);

                    // insertToDatabase(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // ).then((value){
                    //   Navigator.pop(context);
                    //   isBottomSheetShown = false;
                    // });
                  }
                }
                else{
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) => Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0,),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (value){
                                  if(value!.isEmpty){
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Task Title',
                                prefix: Icons.title
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              onTap: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value){
                                  timeController.text = value!.format(context).toString();
                                  print(value?.format(context));
                                });
                              },
                              validate: (value){
                                if(value!.isEmpty){
                                  return 'time must not be empty';
                                }
                                return null;
                              },
                              label: 'Task Time',
                              prefix: Icons.watch_later_outlined,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              onTap: (){
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2024-12-30')
                                ).then((value){
                                  dateController.text = DateFormat.yMMMd().format(value!);
                                });
                              },
                              validate: (value){
                                if(value!.isEmpty){
                                  return 'date must not be empty';
                                }
                                return null;
                              },
                              label: 'Task Date',
                              prefix: Icons.calendar_today,
                            ),

                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  ).closed.then((value){
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }

              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index)
              {

                cubit.changeIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
              },
              items:
              [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu,),
                    label: 'Tasks'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline,),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined,),
                    label: 'Archived'
                ),
              ],
            ),
          );
        },

      ),
    );
  }

  /*Future<String> getName() async
  {
    return 'Ahmed Ali';
  }*/



}


