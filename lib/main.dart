
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/strings.dart';
import 'logic/address/address_cubit.dart';
import 'logic/admin_orders/admin_orders_cubit.dart';
import 'logic/cart/cart_cubit.dart';
import 'logic/cubit/prod_cart_cubit.dart';
import 'logic/items/items_cubit.dart';
import 'logic/language/language_cubit.dart';
import 'logic/manage_items/manage_items_cubit.dart';
import 'logic/navigation_cubit/navigation_cubit.dart';
import 'logic/order/order_cubit.dart';
import 'logic/otp_code_cubit/otp_code_cubit.dart';
import 'logic/phone_auth/phone_auth_cubit.dart';
import 'logic/indicator/page_indicator_cubit.dart';
import 'logic/reports/reports_cubit.dart';
import 'logic/sub_history/sub_history_cubit.dart';
import 'logic/subscription/subscription_cubit.dart';
import 'logic/user/user_cubit.dart';
import 'logic/users/users_cubit.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'logic/auth/auth_cubit.dart';
import 'logic/balance/balance_cubit.dart';

import 'logic/theme/theme_cubit.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MyApp(
      initialRoute: AppRoutes.splash,
      routes: AppRoutes(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRoutes routes;
  final String initialRoute;
  const MyApp({super.key, required this.routes, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageCubit()..getLocale(),
        ),
        BlocProvider(
          create: (context) => PhoneAuthCubit(),
        ),
        BlocProvider(
          create: (context) => SubHistoryCubit(),
        ),
        BlocProvider(
          create: (context) => ManageItemsCubit(),
        ),
        BlocProvider(
          create: (context) => UsersCubit(),
        ),
        BlocProvider(
          create: (context) => ReportsCubit(),
        ),
         BlocProvider(
          create: (context) => ProdCartCubit(),
        ),
        BlocProvider(
          create: (context) => OrderCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => OtpCodeCubit(),
        ),
        BlocProvider(
          create: (context) => AdminOrdersCubit(),
        ),
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => PageIndicatorCubit(),
        ),
        BlocProvider(
          create: (context) => CartCubit(),
        ),
        BlocProvider(
          create: (context) => BalanceCubit()..getBalance(),
        ),
        BlocProvider(
          create: (context) => AddressCubit(),
        ),
        BlocProvider(
          create: (context) => SubscriptionCubit()..getSubs(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => ItemsCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (BuildContext context) => ThemeCubit()..getTheme(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, String>(
        builder: (context, languageState) {
          return BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDark) {
              return MaterialApp(
                locale: Locale(languageState),
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,
                title: appName,
                initialRoute: initialRoute,
                onGenerateRoute: routes.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
