import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Genie/models/login_model.dart';
import 'package:Genie/modules/login/cubit/login_cubit_states.dart';
import 'package:Genie/shared/network/end_points.dart';
import 'package:Genie/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<ShopLoginStates> {
  LoginCubit() : super(ShopLoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  late LoginModel loginModel;
  void toggleIsPassword() {
    isPassword = !isPassword;
    emit(LoginToggleIsPassword());
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoading());
    DioHelper.postData(
      url: login,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(ShopLoginSuccess(loginModel));
    }).catchError((error) {
      emit(ShopLoginError(error.toString()));
    });
  }
}
