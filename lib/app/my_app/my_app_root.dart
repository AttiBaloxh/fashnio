import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fashio/presentation/state_managements/providers/home_provider.dart';
import 'package:fashio/data/repositories_impl/home_repository_impl.dart';
import 'package:fashio/data/data_sources/local/home_local_data_source.dart';
import 'package:fashio/presentation/state_managements/providers/notification_provider.dart';
import 'package:fashio/data/repositories_impl/notification_repository_impl.dart';
import 'package:fashio/data/data_sources/local/notification_local_data_source.dart';
import 'package:fashio/presentation/state_managements/providers/wishlist_provider.dart';
import 'package:fashio/data/repositories_impl/wishlist_repository_impl.dart';
import 'package:fashio/presentation/state_managements/providers/product_details_provider.dart';
import 'package:fashio/presentation/state_managements/providers/review_provider.dart';
import 'package:fashio/presentation/state_managements/providers/cart_provider.dart';
import 'package:fashio/presentation/state_managements/providers/checkout_provider.dart';
import 'package:fashio/presentation/state_managements/providers/order_provider.dart';
import 'package:fashio/presentation/state_managements/providers/wallet_provider.dart';
import 'package:fashio/data/repositories_impl/wallet_repository_impl.dart';
import 'package:fashio/data/data_sources/local/wallet_local_data_source.dart';
import 'package:fashio/presentation/state_managements/providers/profile_provider.dart';
import 'package:fashio/data/repositories_impl/profile_repository_impl.dart';
import 'package:fashio/data/data_sources/local/profile_local_data_source.dart';
import 'package:fashio/config/router/app_router.dart';

class MyAppRoot extends StatelessWidget {
  const MyAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            repository: HomeRepositoryImpl(
              localDataSource: HomeLocalDataSourceImpl(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(
            repository: NotificationRepositoryImpl(
              localDataSource: NotificationLocalDataSourceImpl(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(repository: WishlistRepositoryImpl()),
        ),
        ChangeNotifierProvider(create: (_) => ProductDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(
          create: (_) => WalletProvider(
            repository: WalletRepositoryImpl(
              localDataSource: WalletLocalDataSourceImpl(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            repository: ProfileRepositoryImpl(
              localDataSource: ProfileLocalDataSourceImpl(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Fashio',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          textTheme: GoogleFonts.outfitTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            primary: Colors.black,
          ),
        ),
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
