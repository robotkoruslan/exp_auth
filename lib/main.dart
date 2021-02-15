// import 'package:exp_auth/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'blocs/auth_block.dart';
import 'providers/auth.dart';
import 'providers/transactions.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/transaction_overview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => AuthBloc(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Transactions>(
          create: (_) => Transactions('', '', []),
          update: (ctx, auth, previousTransactions) => Transactions(
              auth.token,
              auth.userId,
              previousTransactions == null
                  ? []
                  : previousTransactions.userTransactions),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Personal Expenses',
          theme: ThemeData(
              primarySwatch: Colors.green,
              primaryColor: Colors.green,
              brightness: Brightness.dark,
              errorColor: Colors.red,
              accentColor: Colors.green,
              fontFamily: 'Quicksand',
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    button: TextStyle(color: Colors.white),
                  ),
              appBarTheme: AppBarTheme(
                color: Colors.green,
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline6: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
              )),
          // home: LoginScreen(),
          home: auth.isAuth
              ? TransactionsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
        ),
      ),
    );
  }
}

// return Provider(
//   create: (contex) => AuthBloc(),
//   child: MaterialApp(
//     title: 'Auth',
//     theme: ThemeData(
//       brightness: Brightness.dark,
//       primaryColor: Colors.blue,
//       visualDensity: VisualDensity.adaptivePlatformDensity,
//     ),
//     home: LoginScreen(),
//   ),
// );
