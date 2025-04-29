import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Genie/layout/shop_layout.dart';
import 'package:Genie/modules/login/log_in_screen.dart';
import 'package:Genie/modules/onboarding/on_boarding_screen.dart';
import 'package:Genie/shared/bloc_observer.dart';
import 'package:Genie/shared/components/constants.dart';
import 'package:Genie/shared/cubit/cubit.dart';
import 'package:Genie/shared/cubit/states.dart';
import 'package:Genie/shared/network/local/cache_helper.dart';
import 'package:Genie/shared/network/remote/dio_helper.dart';
import 'package:Genie/shared/styles/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? storedBool = await CacheHelper.getData(key: 'isDark');
  bool? isGridBool = await CacheHelper.getData(key: 'isGrid');
  bool? onBoardingDone = await CacheHelper.getData(key: 'onBoarding');
  token = await CacheHelper.getData(key: 'token') ?? '';
  String? scheme = await CacheHelper.getData(key: 'scheme');

  // ?print("this is at the start of the app token $token");
  // ?print('me $isGridBool');

  Widget widget;
  if (onBoardingDone != null) {
    if (token.isNotEmpty) {
      widget = const ShopLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }
  runApp(MainApp(
    startWidget: widget,
    isGridBool: isGridBool,
    scheme: scheme,
    storedBool: storedBool,
  ));
}

class MainApp extends StatelessWidget {
  final bool? storedBool;
  final bool? isGridBool;
  final String? scheme;
  final Widget startWidget;
  const MainApp({
    this.storedBool,
    this.isGridBool,
    this.scheme,
    required this.startWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit()
        ..getUserData()
        ..getHomeData()
        ..getCategoriesData()
        ..getFavoritesData()
        ..changeScheme(name: scheme)
        ..toggleTheme(storedBool: storedBool)
        ..toggleIsGrid(storedBool: isGridBool),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ShopCubit cubit = ShopCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: getLightTheme(cubit.currentFlexScheme),
            darkTheme: tempDarkTheme(cubit.currentFlexScheme),
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
