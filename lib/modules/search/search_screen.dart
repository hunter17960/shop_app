import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Genie/shared/components/components.dart';
import 'package:Genie/shared/cubit/cubit.dart';
import 'package:Genie/shared/cubit/states.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final TextEditingController searchController = TextEditingController();

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
        if (state is SearchLoading) {
          return;
        }
      },
      builder: (context, state) {
        ShopCubit shopCubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                shopCubit.searchModel = null;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultFormField(
                    controller: searchController,
                    type: TextInputType.text,
                    onChange: (value) {
                      shopCubit.searchFunction(value);
                    },
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'search must not be null';
                      }
                      return null;
                    },
                    label: 'Search',
                    prefix: Icons.search,
                  ),
                ),
                ConditionalBuilder(
                  condition: shopCubit.searchModel != null,
                  builder: (context) {
                    return viewBuilder(
                      model: shopCubit.searchModel,
                      context: context,
                      isFavorite: false,
                      isSearch: true,
                      isCategory: false,
                    );
                  },
                  fallback: (context) {
                    if (state is SearchLoading) {
                      if (shopCubit.isGrid) {
                        return buildShimmerGrid(context: context);
                      } else {
                        return buildShimmerList(context: context);
                      }
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
