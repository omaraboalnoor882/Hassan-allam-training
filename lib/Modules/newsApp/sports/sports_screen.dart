import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Shared/Components/components.dart';
import '../../../layout/news_app/cubit/cubit.dart';
import '../../../layout/news_app/cubit/states.dart';


class SportsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state){},
      builder: (context, state){
        var list = NewsCubit.get(context).sports;
        return (state is NewsGetSportsLoadingState)?Center(child: CircularProgressIndicator()):ListView.separated(
          itemCount: list.length,
          separatorBuilder: (context,index)=>Container(height: 2,width: double.infinity,color: Colors.grey,),
          itemBuilder:(context,index){
            return buildArticleItem(list[index], context);
          },);
      },
    );
  }
}