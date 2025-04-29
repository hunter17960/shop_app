import 'package:Genie/models/login_model.dart';

abstract class RegisterStates {}

class RegisterInitial extends RegisterStates {}

class RegisterToggleIsPassword extends RegisterStates {}

class RegisterLoading extends RegisterStates {}

class RegisterSuccess extends RegisterStates {
  LoginModel loginModel;
  RegisterSuccess(this.loginModel);
}

class RegisterError extends RegisterStates {
  final String error;
  RegisterError(this.error);
}
