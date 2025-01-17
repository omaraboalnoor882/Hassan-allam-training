
import 'package:course_training/Shared/network/local/cache_helper.dart';
import 'package:course_training/layout/news_app/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Modules/newsApp/buisness/buisness_screen.dart';
import '../../../Modules/newsApp/science/science_screen.dart';
import '../../../Modules/newsApp/sports/sports_screen.dart';
import '../../../Shared/cubit/states.dart';
import '../../../Shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>{

  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.business),
      label: 'Business'
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.sports),
      label: 'Sports'
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.science),
      label: 'Science'
    ),
  ];

  List<Widget> screens = [
    BuisnessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];


  void changeBottomNavBar(int index){
    currentIndex = index;
    if(index == 1)
      getSports();
    if(index == 2)
      getScience();
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];

  void getBusiness(){
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
      url: 'v2/top-headlines ',
      query: {
        'country':'eg',
        'category':'business',
        'apiKey': '3e0212b01d0e47acaa8b652ccf33abd0'
      },
    ).then((value){
      //print(value.data['articles'][0]['title']);
      business = value.data['articles'];
      print(business[0]['title']);

      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  List<dynamic> sports = [];

  void getSports(){
    emit(NewsGetSportsLoadingState());

    if(sports.length == 0){
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country':'eg',
          'category':'sports',
          'apiKey': '3e0212b01d0e47acaa8b652ccf33abd0'
        },
      ).then((value){
        //print(value.data['articles'][0]['title']);
        sports = value.data['articles'];
        print(sports[0]['title']);

        emit(NewsGetSportsSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    }else{
      emit(NewsGetSportsSuccessState());
    }


  }

  List<dynamic> science = [];

  void getScience(){
    emit(NewsGetScienceLoadingState());

    if(science.length == 0){
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country':'eg',
          'category':'science',
          'apiKey': '3e0212b01d0e47acaa8b652ccf33abd0'
        },
      ).then((value){
        //print(value.data['articles'][0]['title']);
        sports = value.data['articles'];
        print(sports[0]['title']);

        emit(NewsGetScienceSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    }else{
      emit(NewsGetScienceSuccessState());
    }

  }

  List<dynamic> search = [];

  void getSearch(String value){

    emit(NewsGetSearchLoadingState());


    DioHelper.getData(
      url: 'v2/everything',
      query: {
        'q':'$value',
        'apiKey': '3e0212b01d0e47acaa8b652ccf33abd0'
      },
    ).then((value){
      //print(value.data['articles'][0]['title']);
      search = value.data['articles'];
      print(search[0]['title']);

      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });

  }





/*
bool isDark = false;
 ThemeMode appMode = ThemeMode.dark;

void changeAppMode({bool fromShared}){
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
  }*/
}