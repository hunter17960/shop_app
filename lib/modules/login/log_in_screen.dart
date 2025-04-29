import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Genie/layout/shop_layout.dart';
import 'package:Genie/modules/login/cubit/login_cubit.dart';
import 'package:Genie/modules/login/cubit/login_cubit_states.dart';
import 'package:Genie/modules/register/register_screen.dart';
import 'package:Genie/shared/components/components.dart';
import 'package:Genie/shared/components/constants.dart';
import 'package:Genie/shared/cubit/cubit.dart';
import 'package:Genie/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final bool isPasswordVisible = true;
  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();

    final emailController = TextEditingController();

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccess) {
            if (state.loginModel.status) {
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                token = state.loginModel.data!.token;
                ShopCubit.get(context).getUserData();
                ShopCubit.get(context).getFavoritesData();
                navigateAndReplace(context, const ShopLayout());
                ShopCubit.get(context).emitNavigatingToShopLayout();
              });
              showToast(
                message: state.loginModel.message,
                context: context,
                state: ToastStates.success,
              );
            } else {
              showToast(
                message: state.loginModel.message,
                context: context,
                state: ToastStates.error,
              );
            }
          } else if (State is ShopLoginError) {
            showToast(
              message: (state as ShopLoginError).error,
              context: context,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          LoginCubit loginCubit = LoginCubit.get(context);
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              loginCubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                            return () {};
                          },
                          isPassword: loginCubit.isPassword,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                            return null;
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                          suffix: loginCubit.isPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          suffixPressed: () {
                            loginCubit.toggleIsPassword();
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoading,
                          builder: (context) {
                            return defaultButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  loginCubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'LOGIN',
                              width: double.infinity,
                              background: Theme.of(context).colorScheme.primary,
                              onBackground:
                                  Theme.of(context).colorScheme.onPrimary,
                            );
                          },
                          fallback: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                            ),
                            TextButton(
                              onPressed: () {
                                navigateAndReplace(context, RegisterScreen());
                              },
                              child: const Text(
                                'Register now',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
