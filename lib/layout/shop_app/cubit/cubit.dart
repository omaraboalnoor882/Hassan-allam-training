import 'package:course_training/Models/shop_app/categories_model.dart';
import 'package:course_training/Models/shop_app/login_model.dart';
import 'package:course_training/Modules/shop_app/cateogries/cateogries_screen.dart';
import 'package:course_training/Modules/shop_app/favorities/favorities_screen.dart';
import 'package:course_training/Modules/shop_app/products/products_screen.dart';
import 'package:course_training/layout/shop_app/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Models/shop_app/change_favorites_model.dart';
import '../../../Models/shop_app/favoritesModel.dart';
import '../../../Models/shop_app/home_model.dart';
import '../../../Modules/shop_app/settings/settings_screen.dart';
import '../../../Shared/Components/Constants.dart';
import '../../../Shared/network/end_points.dart';
import '../../../Shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates>{
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  
  List<Widget> bottomScreens = [
    ProductsScreen(),
    CateogriesScreen(),
    FavoritiesScreen(),
    SettingsScreen(),
  ];
  
  void changeBottom(int index){
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites ={};

  void getHomeData(){
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(url: HOME,token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      printFullText(homeModel.toString());
      //print(homeModel.status);

      homeModel?.data.products.forEach((element){
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      });

      emit(ShopSuccessHomeDataState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }
  CategoriesModel? categoriesModel;

  void getCategories(){

    DioHelper.getData(url: GET_CATEGORIES,token: token).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId){
    favorites[productId] = !favorites[productId]!;
    emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    DioHelper.postData(
        url: FAVORITES,
        data: {
          'product_id' : productId,
        },
        token: token,
    ).then((value) {
          changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
          print(value.data);
          if(!changeFavoritesModel!.status!){
            favorites[productId] = !favorites[productId]!;
          }

          emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error){
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData(){
    emit(ShopLoadingUserDataState());

    DioHelper.getData(url: FAVORITES, token:token).then((value){
      userModel = FavoritesModel.fromJson();
      printFullText(userModel!.data.name);

      emit(ShopSuccessUserDataState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }
}

  FavoritesModel? favoritesModel;

void getFavorites(){

  DioHelper.getData(url: FAVORITES,token: token).then((value) {
    favoritesModel = FavoritesModel.fromJson(value.data);
    printFullText(value.data.toString());
    emit(ShopSuccessGetFavoritesState());
  }).catchError((error){
    print(error.toString());
    emit(ShopErrorGetFavoritesState());
  });
}
