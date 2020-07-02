import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:jsonget/database/favorite_singleton.dart';
import 'package:jsonget/models/Product.dart';
import 'package:jsonget/productInfoPage/ProductInfoScreen.dart';


class FavouritesPageScreen extends StatefulWidget {
  FavouritesPageScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FavouritesPageScreenState createState() => _FavouritesPageScreenState();
}

class _FavouritesPageScreenState extends State<FavouritesPageScreen> {

  ScrollController controller;

  @override
  void initState() {
    controller = new ScrollController();
    super.initState();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        getProductsFromDb();
      }
    });
  }

  Future<List<Product>> getProductsFromDb() async {

    List<Product> products = [];
    products = await FavouriteSingleton().getProducts();

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Center(
            child: Text("Online Shop"),
          )),
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: getProductsFromDb(),
              builder: (BuildContext context, AsyncSnapshot snapShot) {
                if (snapShot.data == null) {
                  return Container(
                    child: Center(child: Text("Loading...")),
                  );
                } else {
                  return Expanded(
                    child: SizedBox(
                      height: 200.0,
                      child: new ListView.builder(
                        itemCount: snapShot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 20),
                                    height: 250,
                                    width: 330,
                                    child: new Image.network(
                                        snapShot.data[index].imageUrl),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ProductInfoScreen(productId: snapShot.data[index].id),
                                    ));
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    height: 50,
                                    width: 400,
                                    margin: EdgeInsets.only(top: 24),
                                    child: Center(
                                      child: new Text(
                                        snapShot.data[index].title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff000066),
                                            fontSize: 22),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ProductInfoScreen(productId: snapShot.data[index].id),
                                    ));
                                  },
                                ),
                                Container(
                                  height: 35,
                                  width: 400,
                                  margin: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: Text(
                                      snapShot.data[index].short_description,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'RobotMono',
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width: 400,
                                  margin: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapShot.data[index].sale_precent > 0
                                              ? (snapShot.data[index].price *
                                              (100 - snapShot.data[index].sale_precent) ~/
                                              100)
                                              .toString() +
                                              '€'
                                              : " ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xff0101DF),
                                              fontSize: 23,
                                              fontFamily: 'RobotMono'),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          snapShot.data[index].price.toString() + '€',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: snapShot.data[index].sale_precent > 0
                                                  ? Color(0xff7F7F7F)
                                                  : Color(0xff0101DF),
                                              decoration: snapShot.data[index].sale_precent > 0
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                              fontSize: snapShot.data[index].sale_precent > 0 ? 18 : 23,
                                              fontFamily: 'RobotMono'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}