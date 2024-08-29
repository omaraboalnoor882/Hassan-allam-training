import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Models/shop_app/categories_model.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';

class CateogriesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state){},
      builder: (context, state){
        return ListView.separated(
          itemBuilder: (context, index) => buildCatItem(ShopCubit.get(context).categoriesModel?.data!.data[index]!),
          separatorBuilder: (context, index) =>, //myDivider(),
          itemCount: ShopCubit.get(context).categoriesModel!.data!.data.length,
        );
      },
    );
  }

  Widget buildCatItem(DataModel model) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Image(image: NetworkImage(model.image),width: 120.0,height: 120.0,fit: BoxFit.cover,),
        SizedBox(width: 20.0,),
        Text(model.name,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
        Spacer(),
        Icon(Icons.arrow_forward_ios),
      ],
    ),
  );
}
