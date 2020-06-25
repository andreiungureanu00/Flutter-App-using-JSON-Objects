import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:jsonget/HomePage.dart';
import 'dart:convert';
import 'package:jsonget/Product.dart';
import 'package:jsonget/ProductInfo.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  ScrollController controller;
  int top, bottom;

  _scrollListener() {
    bottom = 0;
    top = 1;

    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      setState(() {
        bottom = 1;
        top = 0;
      });
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
      setState(() {
        top = 1;
        bottom = 0;
      });
    }
  }

  void initState() {
    controller = ScrollController();
    controller.addListener(_scrollListener);
    super.initState();
  }

  Future<List<Product>> getProducts() async {
    var data = await http
        .get("http://mobile-test.devebs.net:5000/products?limit=10&offset=10");

    var jsonData = json.decode(data.body);

    List<Product> products = [];
    for (var i in jsonData) {
      Product product = Product(
          i["id"], i["title"], i["short_description"], i["image"], i["price"], i["details"]);
      products.add(product);
    }

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
              future: getProducts(),
              // in snapShot will be available the result of getProducts
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
                        controller: controller,
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
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ProductInfo(productId: snapShot.data[index].id),
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
                                    {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ProductInfo(productId: snapShot.data[index].id),
                                      ));
                                    }
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
                                  margin: EdgeInsets.only(top: 10, bottom: 45),
                                  child: Center(
                                    child: Text(
                                      snapShot.data[index].price.toString() +
                                          '€',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff0101DF),
                                          fontSize: 23,
                                          fontFamily: 'RobotMono'),
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
            RaisedButton(
              child: Visibility(
                child: Text("Previous Page"),
                maintainState: true,
                visible: true,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}