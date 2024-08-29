import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Shared/styles/colors.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';

class FavoritiesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state){},
      builder: (context, state){
        return ListView.separated(
            itemBuilder: (context, index) => buildFavItem(ShopCubit.get(context).favoritesModel.data.data[index]),
            separatorBuilder: (context, index) => //myDivider(),
            itemCount: 10,
        );
      },
    );
  }


    Widget buildFavItem(FavoritesData model) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120.0,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.product.image),
                  fit: BoxFit.cover,
                  width: 120.0,
                  height: 120.0,
                ),
                if(model.product.discount != 0)
                  Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 5.0,),
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.white,
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(width: 20.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        model.product.price.toString(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: defaultColor,
                        ),
                      ),
                      SizedBox(width: 5.0,),
                      if(model.product.discount != 0)
                        Text(
                          model.product.oldPrice.toString(),
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                          onPressed: (){
                            ShopCubit.get(context).changeFavoritesModel(model.id);
                            print(model.id);
                          },
                          icon: CircleAvatar(
                              radius: 15.0,
                              backgroundColor: ShopCubit.get(context).favorites[model.id] ? : defaultColor : Colors.grey,
                              child: Icon(
                                Icons.favorite_border,
                                size: 14.0,
                                color: Colors.white,
                              )))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}
