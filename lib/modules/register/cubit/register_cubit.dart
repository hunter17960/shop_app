import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Genie/models/login_model.dart';
import 'package:Genie/modules/register/cubit/register_cubit_states.dart';
import 'package:Genie/shared/network/end_points.dart';
import 'package:Genie/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  late LoginModel loginModel;
  void toggleIsPassword() {
    isPassword = !isPassword;
    emit(RegisterToggleIsPassword());
  }

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoading());
    DioHelper.postData(
      url: register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(RegisterSuccess(loginModel));
    }).catchError((error) {
      emit(RegisterError(error.toString()));
    });
  }
}
