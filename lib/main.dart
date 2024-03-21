import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodapp/ui/admin/edit_product_screen.dart';
import 'package:foodapp/ui/admin/user_product_screen.dart';
import 'package:foodapp/ui/auth/auth_manager.dart';
import 'package:foodapp/ui/auth/auth_screen.dart';
import 'package:foodapp/ui/cart/cart_manager.dart';
import 'package:foodapp/ui/cart/cart_screen.dart';
import 'package:foodapp/ui/order/order_manager.dart';
import 'package:foodapp/ui/order/orders_screen.dart';
import 'package:foodapp/ui/payment_cart/payment_cart_screen.dart';
import 'package:foodapp/ui/products/product_detail_screen.dart';
import 'package:foodapp/ui/products/product_overview_screen.dart';
import 'package:foodapp/ui/products/products_manager.dart';
import 'package:foodapp/ui/splash_screen.dart';
import 'package:provider/provider.dart';

import 'ui/personal/personal_screen.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'ui/products/products_manager.dart';
// import 'ui/products/product_detail_screen.dart';
// // import 'ui/products/product_overview_screen.dart';
// import 'ui/products/product_overview_screen.dart';
// import 'ui/products/user_products_screen.dart';
// import 'ui/cart/cart_screen.dart';
// import 'ui/orders/orders_screen.dart';
// import 'ui/screens.dart';
// import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => AuthManager(),
          ),
          // ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          //     create: (ctx) => ProductsManager(),
          //     update: (ctx, authManager, productsManager) {
          //       // khi authManager co bao hieu thay doi thi doc lai authToken
          //       // cho productManager
          //       productsManager!.authToken = authManager.authToken;
          //       return productsManager;
          //     }),
          ChangeNotifierProvider(
            create: (ctx) => CartManager(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => OrdersManager(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ProductsManager(),
          ),
        ],
        child: Consumer<AuthManager>(builder: (context, authManager, child) {
          return MaterialApp(
            title: 'MyShop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blue,
              ).copyWith(
                secondary: Colors.deepOrange,
              ),
            ),
            home: authManager.isAuth
                ? (context.read<AuthManager>().authToken?.role == "admin"
                    ? const UserProductsScreen()
                    : const ProductsOverviewScreen()
                    )
                : FutureBuilder(
                    future: authManager.tryAutoLogin(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen();
                    },
                  ),
            routes: {
              CartScreen.routeName: (context) => const CartScreen(),
              PersonalScreen.routeName:(context) => const PersonalScreen(),
              PaymentCartScreen1.routeName: (context) =>
                  const PaymentCartScreen1(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName) {
                final productID = settings.arguments as String;
                return MaterialPageRoute(builder: (ctx) {
                  return ProductDetailScreen(
                    ctx.read<ProductsManager>().findById(productID)!,
                    // ProductsManager().findById(productID),
                  );
                });
              }
              if (settings.name == EditProductScreen.routeName) {
                final productId = settings.arguments as String?;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return EditProductScreen(
                      productId != null
                          ? ctx.read<ProductsManager>().findById(productId)
                          : null,
                    );
                  },
                );
              }
              return null;
            },
          );
        }));
  }
}
