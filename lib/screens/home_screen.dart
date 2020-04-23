import 'package:flutter/material.dart';
import 'package:virtual_store/tabs/home_tab.dart';

class HomeScreen extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        //Container(color: Colors.yellow,),
        //Container(color: Colors.red,),
        //Container(color: Colors.green,),
        HomeTab()
      ],
    );
  }
}