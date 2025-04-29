import 'package:Genie/models/login_model.dart';

abstract class ShopLoginStates {}

class ShopLoginInitial extends ShopLoginStates {}

class LoginToggleIsPassword extends ShopLoginStates {}

class ShopLoginLoading extends ShopLoginStates {}

class ShopLoginSuccess extends ShopLoginStates {
  LoginModel loginModel;
  ShopLoginSuccess(this.loginModel);
}

class ShopLoginError extends ShopLoginStates {
  final String error;
  ShopLoginError(this.error);
}
