import 'dart:async';
import 'package:http/http.dart' as http;
// import 'dart:convert';

import 'package:exp_auth/blocs/auth_block.dart';
import 'package:exp_auth/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription<User> loginStateSubscription;
  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }

      fatchInformationFromServer(fbUser.uid);

      // print(fbUser.refreshToken);
      // print(fbUser.refreshToken);
      // print(fbUser.email);
    });

    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  Future<void> fatchInformationFromServer(userId) async {
    final url =
        'https://expense-6e6c7-default-rtdb.firebaseio.com/transactions.json?orderBy="creatorId"&equalTo="$userId"';
    try {
      final response = await http.get(url);
      print(response.body);
      // print(json.decode(response.body));
      // final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // if (extractedData == null) {
      //   return;
      // }
      // final List<Transaction> loadedTransactions = [];
      // extractedData.forEach((transId, transData) {
      //   loadedTransactions.add(Transaction(
      //     id: transId,
      //     title: transData['title'],
      //     amount: transData['amount'],
      //     date: DateTime.fromMillisecondsSinceEpoch(
      //       transData['date'],
      //     ),
      //   ));
      // });
      // userTransactions = loadedTransactions;
      // notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      body: Center(
        child: StreamBuilder<User>(
            stream: authBloc.currentUser,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              // print(snapshot.data.email);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.data.displayName,
                    style: TextStyle(fontSize: 35.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        snapshot.data.photoURL.replaceFirst('s99', 's400')),
                    radius: 60.0,
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  SignInButton(
                    Buttons.Google,
                    text: 'Sign Out of Google',
                    onPressed: () => authBloc.logout(),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
