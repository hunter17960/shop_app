import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Genie/models/categories_model.dart';
import 'package:Genie/models/favorite_model.dart';
import 'package:Genie/models/home_model.dart';
import 'package:Genie/modules/login/log_in_screen.dart';
import 'package:Genie/shared/components/constants.dart';
import 'package:Genie/shared/cubit/cubit.dart';
import 'package:Genie/shared/cubit/states.dart';
import 'package:Genie/shared/network/local/cache_helper.dart';
import 'package:Genie/shared/styles/theme.dart';

enum ToastStates { success, error, warning }

//!                   functions

void signOut(BuildContext context) {
  token = '';
  ShopCubit.get(context).userModel = null;
  CacheHelper.clearData(key: 'token').then((value) {
    if (value) {
      navigateAndReplace(
        context,
        LoginScreen(),
      );
    }
  });
  ShopCubit.get(context).favoritesMap.clear();
}

void navigateTo(context, widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

void navigateAndReplace(context, widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

void showToast({
  required String message,
  required BuildContext context,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state: state, context: context)[0],
    textColor: chooseToastColor(state: state, context: context)[1],
  );
}

List<Color> chooseToastColor({
  required ToastStates state,
  required BuildContext context,
}) {
  late Color color;
  late Color onColor;
  switch (state) {
    case ToastStates.success:
      color = Theme.of(context).colorScheme.primary;
      onColor = Theme.of(context).colorScheme.onPrimary;
      break;
    case ToastStates.error:
      color = Theme.of(context).colorScheme.error;
      onColor = Theme.of(context).colorScheme.onError;
      break;
    case ToastStates.warning:
      color = Theme.of(context).colorScheme.secondary;
      onColor = Theme.of(context).colorScheme.onSecondary;
      break;
    default:
      color = Theme.of(context).colorScheme.error;
      onColor = Theme.of(context).colorScheme.onError;
  }
  return [
    color,
    onColor,
  ];
}

//!                   Widgets

Widget defaultButton({
  double width = double.infinity,
  required Color background,
  required Color onBackground,
  double radius = 25.0,
  required VoidCallback? onPressed,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: onBackground,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function Function(String)? onSubmit,
  final ValueChanged<String>? onChange,
  final VoidCallback? onTap,
  bool isPassword = false,
  required final FormFieldValidator<String> validator,
  required String label,
  required IconData prefix,
  IconData? suffix,
  final VoidCallback? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget buildShimmerList({
  required BuildContext context,
  bool? isHomePage,
  bool? isSettingsPage,
}) {
  return Shimmer.fromColors(
    baseColor: Theme.of(context).primaryColor,
    highlightColor: Theme.of(context).highlightColor,
    direction: ShimmerDirection.ttb,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isHomePage != null) shimmerHomePageBeginning(context),
            if (isSettingsPage != null) shimmerSettingsPageBeginning(context),
            shimmerListCard(context),
            const SizedBox(height: 8.0),
            shimmerListCard(context),
            const SizedBox(height: 8.0),
            shimmerListCard(context),
            const SizedBox(height: 8.0),
            shimmerListCard(context),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    ),
  );
}

Widget buildShimmerGrid({
  required BuildContext context,
  bool? isHomePage,
  bool? isSettingsPage,
}) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Shimmer.fromColors(
      baseColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
      direction: ShimmerDirection.ttb,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isHomePage != null) shimmerHomePageBeginning(context),
          if (isSettingsPage != null) shimmerSettingsPageBeginning(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                6,
                (index) => Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 3.3,
                        width: double.infinity,
                        child: shimmerGridCard(context),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 3.3,
                        width: double.infinity,
                        child: shimmerGridCard(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget shimmerListCard(BuildContext context) {
  return Card(
    color: Theme.of(context).dividerColor,
    child: Row(
      children: [
        Container(
          color: Theme.of(context).dividerColor,
          height: 150,
          width: 150,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 15.0,
                color: Theme.of(context).dividerColor,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                height: 15.0,
                color: Theme.of(context).dividerColor,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                height: 15.0,
                color: Theme.of(context).dividerColor,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
      ],
    ),
  );
}

Widget shimmerGridCard(BuildContext context) {
  return Card(
    color: Theme.of(context).dividerColor,
    child: Column(
      children: [
        Expanded(
          child: Container(
            color: Theme.of(context).dividerColor,
          ),
        ),
        Container(
          color: Theme.of(context).dividerColor,
        ),
      ],
    ),
  );
}

Widget shimmerHomePageBeginning(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: MediaQuery.of(context).size.height / 4,
        width: double.infinity,
        color: Theme.of(context).dividerColor,
      ),
      const SizedBox(
        height: 10.0,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height / 50,
          width: MediaQuery.of(context).size.width / 2.5,
          color: Theme.of(context).dividerColor,
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 7.5,
              width: MediaQuery.of(context).size.width / 4,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 7.5,
            width: MediaQuery.of(context).size.width / 4,
            color: Theme.of(context).dividerColor,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 7.5,
            width: MediaQuery.of(context).size.width / 4,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
      const SizedBox(
        height: 10.0,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height / 50,
          width: MediaQuery.of(context).size.width / 2.5,
          color: Theme.of(context).dividerColor,
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
    ],
  );
}

Widget shimmerSettingsPageBeginning(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            maxRadius: MediaQuery.of(context).size.height / 7,
            backgroundColor: Theme.of(context).dividerColor,
          ),
          CircleAvatar(
            // maxRadius: MediaQuery.of(context).size.height / 30,
            backgroundColor: Theme.of(context).dividerColor,
            // maxRadius: MediaQuery.of(context).size.height / 30,
            child: const Icon(
              Icons.edit,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
          height: MediaQuery.of(context).size.height / 11.5,
          width: double.infinity,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
          height: MediaQuery.of(context).size.height / 11.5,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
          height: MediaQuery.of(context).size.height / 11.5,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
          height: MediaQuery.of(context).size.height / 11.5,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
          height: MediaQuery.of(context).size.height / 11.5,
        ),
      ),
    ],
  );
}

Widget buildCachedNetworkImage({
  required String url,
  required bool isCard,
  required BuildContext context,
  double? height,
  double? width,
}) {
  if (isCard) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height ?? MediaQuery.of(context).size.height / 4.8,
      width: width ?? double.infinity,
      errorWidget: (context, url, error) => const Padding(
        padding: EdgeInsets.all(20.0),
        child: Image(
          image: AssetImage(
            'assets/images/errorImage.png',
          ),
        ),
      ),
      fit: BoxFit.cover,
      placeholder: (context, url) => buildShimmerImage(
        context: context,
        isCard: isCard,
      ),
    );
  } else {
    return CachedNetworkImage(
      imageUrl: url,
      height: height ?? 150.0,
      width: width ?? 150.0,
      errorWidget: (context, url, error) => const Padding(
        padding: EdgeInsets.all(20.0),
        child: Image(
          image: AssetImage(
            'assets/images/errorImage.png',
          ),
        ),
      ),
      fit: BoxFit.cover,
      placeholder: (context, url) => buildShimmerImage(
        context: context,
        isCard: isCard,
      ),
    );
  }
}

Widget buildShimmerImage({
  required BuildContext context,
  required bool isCard,
}) {
  if (isCard) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).highlightColor,
      child: Container(
        height: 190.0,
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  } else {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).highlightColor,
      child: Container(
        height: 150.0,
        width: 150.0,
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }
}

//?   Deciding on  Box or  Tile for the Products

Widget viewBuilder({
  required dynamic model,
  required BuildContext context,
  required bool isFavorite,
  required bool isSearch,
  required bool isCategory,
}) {
  if (ShopCubit.get(context).isGrid) {
    return GridView.count(
      padding: const EdgeInsets.all(8.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 5.0,
      childAspectRatio: 1 / 1.43,
      children: List.generate(
        isCategory
            ? model!.data!.categories.length
            : isFavorite
                ? model.data!.favoritesProducts.length
                : model.data!.products.length,
        (index) => boxCardBuilder(
          context: context,
          productModel: isCategory
              ? model.data.categories[index]
              : isFavorite
                  ? model.data.favoritesProducts[index]
                  : model.data!.products[index],
          isFavorite: isFavorite,
          isSearch: isSearch,
          isCategory: isCategory,
        ),
      ),
    );
  } else {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        isCategory
            ? model!.data!.categories.length
            : isFavorite
                ? model.data!.favoritesProducts.length
                : model.data!.products.length,
        (index) => tileCardBuilder(
          context: context,
          productModel: isCategory
              ? model.data.categories[index]
              : isFavorite
                  ? model.data.favoritesProducts[index]
                  : model.data!.products[index],
          isFavorite: isFavorite,
          isSearch: isSearch,
          isCategory: isCategory,
        ),
      ),
    );
  }
}

Widget boxCardBuilder({
  required dynamic productModel,
  required bool isSearch,
  required bool isFavorite,
  required bool isCategory,
  required BuildContext context,
}) {
  if (!isCategory) {
    return InkWell(
      onTap: () {},
      child: Stack(
        children: [
          Card(
            child: Column(
              children: [
                buildCachedNetworkImage(
                  url: productModel.image,
                  isCard: true,
                  context: context,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          productModel.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${productModel.price}',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            if (!isSearch)
                              if (productModel.discount != 0)
                                Text(
                                  '${productModel.oldPrice}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            CircleAvatar(
                              maxRadius: 20,
                              backgroundColor:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              child: IconButton(
                                onPressed: () {
                                  if (isFavorite) {
                                    ShopCubit.get(context).changeFavorites(
                                        productId: productModel.id);
                                    ShopCubit.get(context)
                                        .favoritesModel!
                                        .data!
                                        .favoritesProducts
                                        .remove(productModel);
                                  } else {
                                    ShopCubit.get(context).changeFavorites(
                                        productId: productModel.id);
                                  }
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                ),
                                isSelected: isFavorite
                                    ? ShopCubit.get(context)
                                            .favoritesMap[productModel.id] ??
                                        true
                                    : ShopCubit.get(context)
                                        .favoritesMap[productModel.id],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (!isSearch)
            if (productModel.discount != 0)
              Positioned(
                right: 5,
                top: 5,
                child: Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ),
              ),
          // Positioned(
          //   right: 5,
          //   bottom: 95,
          //   child: CircleAvatar(
          //     backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          //     child: IconButton(
          //       onPressed: () {
          //         if (isFavorite) {
          //           ShopCubit.get(context)
          //               .changeFavorites(productId: productModel.id);
          //           ShopCubit.get(context)
          //               .favoritesModel!
          //               .data!
          //               .favoritesProducts
          //               .remove(productModel);
          //         } else {
          //           ShopCubit.get(context)
          //               .changeFavorites(productId: productModel.id);
          //         }
          //       },
          //       icon: const Icon(
          //         Icons.favorite,
          //       ),
          //       isSelected: isFavorite
          //           ? ShopCubit.get(context).favoritesMap[productModel.id] ??
          //               true
          //           : ShopCubit.get(context).favoritesMap[productModel.id],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  } else {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildCachedNetworkImage(
              url: productModel.image,
              isCard: true,
              context: context,
            ),
            Expanded(
              child: Center(
                child: Text(
                  productModel.name,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget tileCardBuilder({
  required dynamic productModel,
  required bool isSearch,
  required bool isFavorite,
  required bool isCategory,
  required BuildContext context,
}) {
  if (!isCategory) {
    return InkWell(
      onTap: () {},
      child: Stack(
        children: [
          Card(
            child: Row(
              children: [
                buildCachedNetworkImage(
                  url: productModel.image,
                  isCard: false,
                  context: context,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              productModel.name,
                              maxLines: 4,
                              // overflow: TextOverflow.ellipsis,
                              style: const TextStyle(),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '${productModel.price}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              if (!isSearch)
                                if (productModel.discount != 0)
                                  Text(
                                    '${productModel.oldPrice}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .unselectedWidgetColor,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (!isSearch)
            if (productModel.discount != 0)
              Positioned(
                left: 0,
                top: 0,
                child: Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ),
              ),
          Positioned(
            right: 5,
            bottom: 5,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              child: IconButton(
                onPressed: () {
                  if (isFavorite) {
                    ShopCubit.get(context)
                        .changeFavorites(productId: productModel.id);
                    ShopCubit.get(context)
                        .favoritesModel!
                        .data!
                        .favoritesProducts
                        .remove(productModel);
                  } else {
                    ShopCubit.get(context)
                        .changeFavorites(productId: productModel.id);
                  }
                },
                icon: const Icon(
                  Icons.favorite,
                ),
                isSelected: isFavorite
                    ? ShopCubit.get(context).favoritesMap[productModel.id] ??
                        true
                    : ShopCubit.get(context).favoritesMap[productModel.id],
              ),
            ),
          )
        ],
      ),
    );
  } else {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Row(
          children: [
            buildCachedNetworkImage(
              url: productModel.image,
              isCard: false,
              context: context,
            ),
            Expanded(
              child: Center(
                child: Text(
                  productModel.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//?
Widget buildCategoryItem(CategoryModel model, BuildContext context) {
  return Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      buildCachedNetworkImage(
        context: context,
        isCard: true,
        url: model.image,
        height: 100,
        width: 100,
      ),
      Container(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        width: 100.0,
        child: Text(
          model.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    ],
  );
}

Widget homeScreenWidget({
  required HomeModel model,
  required CategoriesModel categories,
  required BuildContext context,
}) =>
    SingleChildScrollView(
      child: Column(
        children: [
          //!Slide Show for banners!

          CarouselSlider(
            items: model.data!.banners
                .map(
                  (e) => buildCachedNetworkImage(
                    context: context,
                    isCard: true,
                    url: e.image,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              scrollPhysics: const BouncingScrollPhysics(),
              height: MediaQuery.of(context).size.height / 4,
              initialPage: 0,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),

          const SizedBox(
            height: 10.0,
          ),

          //!Row Of Categories In homeScreen

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 100.0, //!                        to do
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => buildCategoryItem(
                        categories.data!.categories[index], context),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10.0,
                    ),
                    itemCount: categories.data!.categories.length,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  'New Products',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),

          //!List of Products

          viewBuilder(
            model: model,
            context: context,
            isFavorite: false,
            isSearch: false,
            isCategory: false,
          )
        ],
      ),
    );

Widget favoritesScreenWidget({
  required FavoritesModel favoritesModel,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        viewBuilder(
          model: favoritesModel,
          context: context,
          isFavorite: true,
          isSearch: false,
          isCategory: false,
        )
      ],
    ),
  );
}

Widget categoriesScreenWidget({
  required model,
  required BuildContext context,
  required isFavorite,
  required isSearch,
  required isCategory,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        viewBuilder(
          model: model,
          context: context,
          isFavorite: isFavorite,
          isSearch: isSearch,
          isCategory: isCategory,
        ),
      ],
    ),
  );
}

Widget settingsScreenWidget({
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController phoneController,
  required GlobalKey<FormState> formKey,
  required ShopStates state,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (state is ShopLoadingUpdateUser) const LinearProgressIndicator(),
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
                children: List.generate(FlexScheme.values.length - 1, (index) {
                  FlexScheme flex = FlexScheme.values[index];
                  return buildThemeColorGridCard(flex, index, context);
                }),
              ),
            if (!ShopCubit.get(context).isGrid)
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(FlexScheme.values.length - 1, (index) {
                  FlexScheme flex = FlexScheme.values[index];
                  return buildThemeColorListCard(flex, index, context);
                }),
              )
          ],
        ),
      ),
    ),
  );
}

Widget buildThemeColorListCard(
    FlexScheme flex, int index, BuildContext context) {
  return InkWell(
    onTap: () {
      ShopCubit.get(context).changeScheme(name: flex.name);
    },
    child: SizedBox(
      width: double.infinity,
      height: 150,
      child: Card(
        margin: const EdgeInsets.all(5),
        child: Row(
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  color:
                                      tempDarkTheme(flex).colorScheme.primary,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    color: tempDarkTheme(flex)
                                        .colorScheme
                                        .primaryContainer),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  color: tempDarkTheme(FlexScheme.values[index])
                                      .colorScheme
                                      .secondary,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    color:
                                        tempDarkTheme(FlexScheme.values[index])
                                            .colorScheme
                                            .secondaryContainer),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  flex.name,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget buildThemeColorGridCard(
    FlexScheme flex, int index, BuildContext context) {
  return InkWell(
    onTap: () {
      ShopCubit.get(context).changeScheme(name: flex.name);
    },
    child: Card(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: tempDarkTheme(flex).colorScheme.primary,
                        ),
                      ),
                      Expanded(
                        child: Container(
                            width: double.infinity,
                            color: tempDarkTheme(flex)
                                .colorScheme
                                .primaryContainer),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: tempDarkTheme(FlexScheme.values[index])
                              .colorScheme
                              .secondary,
                        ),
                      ),
                      Expanded(
                        child: Container(
                            width: double.infinity,
                            color: tempDarkTheme(FlexScheme.values[index])
                                .colorScheme
                                .secondaryContainer),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              flex.name,
              maxLines: 1,
            ),
          )
        ],
      ),
    ),
  );
}
