import 'package:course_training/Shared/Components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/news_app/cubit/cubit.dart';
import '../../../layout/news_app/cubit/states.dart';

class SearchScreen extends StatelessWidget {

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state){},
      builder: (context, state){
        var list = NewsCubit.get(context).search;

        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultFormField(
                    controller: searchController,
                    type: TextInputType.text,
                    onChanged: (value){
                      NewsCubit.get(context).getSearch(value);
                    },
                    validate: (String? value){
                      if(value!.isEmpty){
                        return 'search must not be empty';
                      }
                      return null;
                    },
                    label: 'Search',
                    prefix: Icons.search,
                ),
              ),
        (state is NewsGetSearchLoadingState)?Center(child: CircularProgressIndicator()):Expanded(
          child: ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (context,index)=>Container(height: 2,width: double.infinity,color: Colors.grey,),
                  itemBuilder:(context,index){
                  return buildArticleItem(list[index], context);
                  },),
        ),
            ],
          ),
        );
      },
    );
  }
}
