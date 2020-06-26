import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsonget/productsPage/ProductsPageScreen.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductsPageScreen(title: 'Flutter Demo Home Page'),
    );
  }
}
