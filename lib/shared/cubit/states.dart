import 'package:Genie/models/change_favorites_model.dart';
import 'package:Genie/models/favorite_model.dart';
import 'package:Genie/models/login_model.dart';
import 'package:Genie/models/search_model.dart';

abstract class ShopStates {}

class ShopInitial extends ShopStates {}

class ShopNavigatingToShopLayout extends ShopStates {}

class ShopToggleTheme extends ShopStates {}

class ShopToggleIsGrid extends ShopStates {}

class ShopToggleFavorite extends ShopStates {}

class ShopToggleFavoriteSuccess extends ShopStates {
  final ChangeFavoritesModel model;
  ShopToggleFavoriteSuccess(this.model);
}

class ShopToggleFavoriteError extends ShopStates {
  String error;
  ShopToggleFavoriteError(this.error);
}

class ShopChangeBottomNavBar extends ShopStates {}

class ShopLoadingHomeData extends ShopStates {}

class ShopLoadingHomeDataSuccess extends ShopStates {}

class ShopLoadingHomeDataError extends ShopStates {
  String error;
  ShopLoadingHomeDataError(this.error);
}

class ShopLoadingCategoriesData extends ShopStates {}

class ShopLoadingCategoriesDataSuccess extends ShopStates {}

class ShopLoadingCategoriesDataError extends ShopStates {
  String error;
  ShopLoadingCategoriesDataError(this.error);
}

class ShopLoadingFavoritesData extends ShopStates {}

class ShopLoadingFavoritesDataSuccess extends ShopStates {
  FavoritesModel favoritesModel;
  ShopLoadingFavoritesDataSuccess(this.favoritesModel);
}

class ShopLoadingFavoritesDataError extends ShopStates {
  String error;
  ShopLoadingFavoritesDataError(this.error);
}

class ShopLoadingUserData extends ShopStates {}

class ShopLoadingUserDataSuccess extends ShopStates {
  final LoginModel userModel;
  ShopLoadingUserDataSuccess(this.userModel);
}

class ShopLoadingUserDataError extends ShopStates {
  String error;
  ShopLoadingUserDataError(this.error);
}

class ShopLoadingUpdateUser extends ShopStates {}

class ShopSuccessUpdateUser extends ShopStates {
  final LoginModel loginModel;
  ShopSuccessUpdateUser(this.loginModel);
}

class ShopErrorUpdateUser extends ShopStates {
  String error;
  ShopErrorUpdateUser(this.error);
}

class ChangeScheme extends ShopStates {}

class ShopToggleIsImageLoaded extends ShopStates {}

class SearchLoading extends ShopStates {}

class SearchLoadingSuccess extends ShopStates {
  SearchModel searchModel;
  SearchLoadingSuccess(this.searchModel);
}

class SearchLoadingError extends ShopStates {
  final String error;
  SearchLoadingError(this.error);
}
