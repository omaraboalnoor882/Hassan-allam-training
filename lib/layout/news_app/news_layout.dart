import 'package:course_training/Shared/Components/components.dart';
import 'package:course_training/layout/news_app/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Modules/newsApp/search/search_screen.dart';
import '../../Shared/cubit/cubit.dart';
import 'cubit/states.dart';

class NewsLayout extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state){
        var cubit = NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('News App'),
        actions: [
          IconButton(onPressed: (){
           navigateTo(context, SearchScreen());
          }, icon: Icon(Icons.search)),
          IconButton(onPressed: (){
            AppCubit.get(context).changeAppMode();
          }, icon: Icon(Icons.brightness_2_outlined)),
        ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: cubit.bottomItems,
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNavBar(index);
          },
          ),
        );
      },
    );
  }
}
