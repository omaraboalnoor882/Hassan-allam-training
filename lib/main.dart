import 'package:bloc/bloc.dart';
import 'package:course_training/Modules/shop_app/login/shop_login_screen.dart';
import 'package:course_training/Modules/shop_app/onboarding_screen/onboarding_screen.dart';
import 'package:course_training/Shared/cubit/cubit.dart';
import 'package:course_training/Shared/network/local/cache_helper.dart';
import 'package:course_training/layout/shop_app/shop_layout.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'Shared/block_observer.dart';
import 'Shared/cubit/states.dart';
import 'Shared/network/remote/dio_helper.dart';
import 'Shared/styles/themes.dart';
import 'layout/news_app/cubit/cubit.dart';
import 'layout/shop_app/cubit/cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');

  Widget widget; //Widget widget

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  String? token = CacheHelper.getData(key: 'token');
  print(token);

  if(onBoarding != null){
    if(token != null) widget = ShopLayout();//widget
    else widget = ShopLoginScreen();//widget
  }else{
    widget = OnBoardingScreen();//widget
  }

  runApp(MyApp(
      isDark??isDark!,
      widget?? widget //widget in the last
  ));
}

class MyApp extends StatelessWidget{
  final bool isDark;
  final Widget startWidget;// no?
  MyApp(this.isDark, this.startWidget);
  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>AppCubit()),
        BlocProvider(create: (context) => NewsCubit()..getBusiness()..getSports()..getScience(),),
        BlocProvider(create: (context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){},
        builder: (context, state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            //darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}