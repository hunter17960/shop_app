import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Genie/shared/components/components.dart';
import 'package:Genie/shared/cubit/cubit.dart';
import 'package:Genie/shared/cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessUpdateUser) {
          if (state.loginModel.status) {
            showToast(
              message: state.loginModel.message,
              context: context,
              state: ToastStates.success,
            );
          } else {
            ShopCubit.get(context).getUserData();
            showToast(
              message: state.loginModel.message,
              context: context,
              state: ToastStates.warning,
            );
          }
        }
        if (State is ShopErrorUpdateUser) {
          showToast(
            message: 'error',
            context: context,
            state: ToastStates.error,
          );
        }
      },
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;

        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          fallback: (context) => ShopCubit.get(context).isGrid
              ? buildShimmerGrid(context: context, isSettingsPage: true)
              : buildShimmerList(context: context, isSettingsPage: true),
          builder: (context) {
            if (model?.data != null) {
              nameController.text = model!.data!.name;
              emailController.text = model.data!.email;
              phoneController.text = model.data!.phone;
            }
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (state is ShopLoadingUpdateUser)
                        const LinearProgressIndicator(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            maxRadius: MediaQuery.of(context).size.height / 7,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: buildCachedNetworkImage(
                                url: model!.data!.image,
                                isCard: true,
                                context: context,
                                width: 200,
                                height: 200,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'name must not be empty';
                          }

                          return null;
                        },
                        label: 'Name',
                        prefix: Icons.person,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'email must not be empty';
                          }

                          return null;
                        },
                        label: 'Email Address',
                        prefix: Icons.email,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'phone must not be empty';
                          }
                          return null;
                        },
                        label: 'Phone',
                        prefix: Icons.phone,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ShopCubit.get(context).updateUserData(
                              name: nameController.text,
                              phone: phoneController.text,
                              email: emailController.text,
                            );
                          }
                        },
                        background: Theme.of(context).colorScheme.primary,
                        onBackground: Theme.of(context).colorScheme.onPrimary,
                        text: 'update',
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultButton(
                        onPressed: () {
                          signOut(context);
                        },
                        background: Theme.of(context).colorScheme.primary,
                        onBackground: Theme.of(context).colorScheme.onPrimary,
                        text: 'Logout',
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        height: 100,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Dark Mode',
                                  style: TextStyle(fontSize: 25),
                                ),
                                Switch(
                                  value: ShopCubit.get(context).isDark,
                                  onChanged: (value) {
                                    ShopCubit.get(context).toggleTheme();
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Grid',
                                  style: TextStyle(fontSize: 25),
                                ),
                                const Icon(
                                  Icons.grid_view_rounded,
                                  size: 50,
                                ),
                                Switch(
                                  value: ShopCubit.get(context).isGrid,
                                  onChanged: (value) {
                                    ShopCubit.get(context).toggleIsGrid();
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'List',
                                  style: TextStyle(fontSize: 25),
                                ),
                                const Icon(
                                  Icons.list_rounded,
                                  size: 50,
                                ),
                                Switch(
                                  value: !ShopCubit.get(context).isGrid,
                                  onChanged: (value) {
                                    ShopCubit.get(context).toggleIsGrid();
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (ShopCubit.get(context).isGrid)
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          children: List.generate(FlexScheme.values.length - 1,
                              (index) {
                            FlexScheme flex = FlexScheme.values[index];
                            return buildThemeColorGridCard(
                                flex, index, context);
                          }),
                        ),
                      if (!ShopCubit.get(context).isGrid)
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(FlexScheme.values.length - 1,
                              (index) {
                            FlexScheme flex = FlexScheme.values[index];
                            return buildThemeColorListCard(
                                flex, index, context);
                          }),
                        )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
