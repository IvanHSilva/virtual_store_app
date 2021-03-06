import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/cart_model.dart';
import 'package:virtual_store/screens/home_screen.dart';
//import 'package:virtual_store/screens/login_screen.dart';
//import 'package:virtual_store/screens/signup_screen.dart';

import 'models/user_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(), 
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: 'Flutters Clothing',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 4, 125, 141)
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(), //HomeScreen(),
            ),
          );
        }
      ),
    );
  }
}