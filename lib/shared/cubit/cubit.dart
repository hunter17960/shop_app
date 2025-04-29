import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Genie/models/categories_model.dart';
import 'package:Genie/models/change_favorites_model.dart';
import 'package:Genie/models/favorite_model.dart';
import 'package:Genie/models/home_model.dart';
import 'package:Genie/models/login_model.dart';
import 'package:Genie/models/search_model.dart';
import 'package:Genie/modules/categories/categories_screen.dart';
import 'package:Genie/modules/favorites/favorites_screen.dart';
import 'package:Genie/modules/products/products_screen.dart';
import 'package:Genie/modules/settings_/settings_screen.dart';
import 'package:Genie/shared/components/constants.dart';
import 'package:Genie/shared/cubit/states.dart';
import 'package:Genie/shared/network/end_points.dart';
import 'package:Genie/shared/network/local/cache_helper.dart';
import 'package:Genie/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitial());
  static ShopCubit get(context) => BlocProvider.of(context);
  bool isDark = false;
  bool isGrid = false;
  bool isImageLoaded = false;
  int currentIndex = 0;
  Map<int, bool> favoritesMap = {};
  FlexScheme currentFlexScheme = FlexScheme.money;
  void emitNavigatingToShopLayout() {
    emit(ShopNavigatingToShopLayout());
  }

  List<Widget> screens = [
    const ProductsScreen(),
    const FavoritesScreen(),
    const CategoriesScreen(),
    SettingsScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavBar());
  }

  void changeScheme({String? name}) {
    if (name != null) {
      currentFlexScheme =
          FlexScheme.values.where((element) => element.name == name).single;
      CacheHelper.saveData(key: 'scheme', value: name);
      emit(ChangeScheme());
    } else {}
    // print('the current ${currentFlexScheme.name}');
    // print('the sent $name');
    emit(ChangeScheme());
  }

  void toggleTheme({bool? storedBool}) {
    if (storedBool != null) {
      isDark = storedBool;
      emit(ShopToggleTheme());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(ShopToggleTheme());
      });
    }
  }

  void toggleIsGrid({bool? storedBool}) {
    if (storedBool != null) {
      isGrid = storedBool;
      emit(ShopToggleIsGrid());
    } else {
      isGrid = !isGrid;
      CacheHelper.saveData(key: 'isGrid', value: isGrid).then((value) async {
        // bool v = await CacheHelper.getData(key: 'isGrid');
        // print(v);
        emit(ShopToggleIsGrid());
      });
    }
  }

  HomeModel? homeModel;
  void getHomeData() {
    emit(ShopLoadingHomeData());
    DioHelper.getData(
      url: home,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      for (var element in homeModel!.data!.products) {
        favoritesMap.addAll({
          element.id: element.favorite ?? false,
        });
      }
      emit(ShopLoadingHomeDataSuccess());
    }).catchError((error) {
      //!print(error.toString());
      emit(ShopLoadingHomeDataError(error.toString()));
    });
  }

  CategoriesModel? categoriesModel;
  void getCategoriesData() {
    emit(ShopLoadingCategoriesData());
    DioHelper.getData(
      url: categories,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopLoadingCategoriesDataSuccess());
    }).catchError((error) {
      // print(error.toString());
      emit(ShopLoadingCategoriesDataError(error.toString()));
    });
  }

  FavoritesModel? favoritesModel;

  void getFavoritesData() {
    emit(ShopLoadingFavoritesData());
    DioHelper.getData(
      url: favorites,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      for (var element in favoritesModel!.data!.favoritesProducts) {
        favoritesMap.addAll({
          element.id: element.favorite ?? false,
        });
      }
      emit(ShopLoadingFavoritesDataSuccess(favoritesModel!));
    }).catchError((error) {
      //!print(error.toString());
      emit(ShopLoadingFavoritesDataError(error.toString()));
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites({required int productId}) {
    // print(' it was${favoritesMap[productId]}');
    favoritesMap[productId] = !favoritesMap[productId]!;
    // print(' it is now ${favoritesMap[productId]}');

    emit(ShopToggleFavorite());
    DioHelper.postData(
      url: favorites,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      // print(value.data.toString());

      if (!changeFavoritesModel!.status) {
        favoritesMap[productId] = !favoritesMap[productId]!;
        // print(' sorry there was an error${favoritesMap[productId]}');
      } else {
        // print(favoritesMap[productId]);
        getFavoritesData();
      }
      emit(ShopToggleFavoriteSuccess(changeFavoritesModel!));
    }).catchError((error) {
      favoritesMap[productId] = !favoritesMap[productId]!;
      // print(' sorry there was an error 2${favoritesMap[productId]}');
      // print(error.toString());
      ShopToggleFavoriteError(error);
    });
  }

  SearchModel? searchModel;
  void searchFunction(String text) {
    emit(SearchLoading());

    DioHelper.postData(
      url: search,
      token: token,
      data: {
        'text': text,
      },
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      //! print(searchModel!.data!.products[0].name);
      //! print(searchModel!.data!.products[0].image);
      emit(SearchLoadingSuccess(searchModel!));
    }).catchError((error) {
      //!print(error.toString());
      emit(SearchLoadingError(error.toString()));
    });
  }

  LoginModel? userModel;
  LoginModel? userModelOnError;

  void getUserData() {
    emit(ShopLoadingUserData());

    DioHelper.getData(
      url: profile,
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      // print(userModel!.data!.name);

      emit(ShopLoadingUserDataSuccess(userModel!));
    }).catchError((error) {
      //!print(error.toString());
      emit(ShopLoadingUserDataError(error.toString()));
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUser());
    DioHelper.putData(
      url: updateProfile,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      if (value.data['status']) {
        userModel = LoginModel.fromJson(value.data);
        emit(ShopSuccessUpdateUser(userModel!));
      } else {
        userModelOnError = LoginModel.fromJson(value.data);
        emit(ShopSuccessUpdateUser(userModelOnError!));
      }
    }).catchError((error) {
      //!print(error.toString());
      emit(ShopErrorUpdateUser(error.toString()));
    });
  }
}
