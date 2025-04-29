import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Genie/shared/components/components.dart';
import 'package:Genie/shared/cubit/cubit.dart';
import 'package:Genie/shared/cubit/states.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopToggleFavoriteSuccess) {
          if (!state.model.status) {
            showToast(
              message: state.model.message,
              context: context,
              state: ToastStates.error,
            );
          }
        }
        if (state is ShopToggleFavoriteError) {
          showToast(
            message: state.error,
            context: context,
            state: ToastStates.warning,
          );
        }
      },
      builder: (context, state) {
        ShopCubit shopCubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: shopCubit.homeModel != null,
          builder: (context) {
            return homeScreenWidget(
              context: context,
              model: shopCubit.homeModel!,
              categories: shopCubit.categoriesModel!,
            );
          },
          fallback: (context) {
            if (shopCubit.isGrid) {
              return buildShimmerGrid(
                context: context,
                isHomePage: true,
              );
            } else {
              return buildShimmerList(
                context: context,
                isHomePage: true,
              );
            }
          },
        );
      },
    );
  }
}
