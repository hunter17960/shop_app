import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Genie/shared/components/components.dart';
import 'package:Genie/shared/cubit/cubit.dart';
import 'package:Genie/shared/cubit/states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit shopCubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: shopCubit.categoriesModel != null,
          builder: (context) {
            return categoriesScreenWidget(
              context: context,
              model: shopCubit.categoriesModel,
              isFavorite: false,
              isSearch: false,
              isCategory: true,
            );
          },
          fallback: (context) {
            if (shopCubit.isGrid) {
              return buildShimmerGrid(context: context);
            } else {
              return buildShimmerList(context: context);
            }
          },
        );
      },
    );
  }
}
