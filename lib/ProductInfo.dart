import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jsonget/Product.dart';

class ProductInfo extends StatefulWidget {

  ProductInfo({Key key, this.title, this.productId}) : super(key: key);

  final String title;
  final int productId;

  @override
  ProductInfoState createState() => ProductInfoState(productId);
}

class ProductInfoState extends State<ProductInfo> {

  Product product;
  int productId;

  ProductInfoState(this.productId);

  Future<Product> getProduct() async {
    String url = "http://mobile-test.devebs.net:5000/product?id=";

    url = url + productId.toString();
    var data = await http.get(url);
    var jsonData = json.decode(data.body);

    product = Product(jsonData["id"], jsonData["title"], jsonData["short_description"],
        jsonData["image"], jsonData["price"], jsonData["details"]);

    return product;
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
              future: getProduct(),
              // in snapShot will be available the result of getProducts
              builder: (BuildContext context, AsyncSnapshot snapShot) {
                if (snapShot.data == null) {
                  return Container(
                    child: Center(
                        child: new Text(
                          "Loading ...",
                          textAlign: TextAlign.center,
                        )
                    ),
                  );
                } else {
                  return Material(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  height: 250,
                                  width: 330,
                                  child: new Image.network(
                                      snapShot.data.imageUrl),
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  height: 50,
                                  width: 400,
                                  margin: EdgeInsets.only(top: 24),
                                  child: Center(
                                    child: new Text(
                                      snapShot.data.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff000066),
                                          fontSize: 22),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 35,
                                width: 400,
                                margin: EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Text(
                                    snapShot.data.short_description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'RobotMono',
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 400,
                                margin: EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Text(
                                    snapShot.data.price.toString() +
                                        '€',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff0101DF),
                                        fontSize: 23,
                                        fontFamily: 'RobotMono'),
                                  ),
                                ),
                              ),
                              Container(
                                height: 80,
                                width: 400,
                                margin: EdgeInsets.only(top: 30, bottom: 45),
                                child: Container(
                                  child: SingleChildScrollView(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(),
                                      child: Center(
                                        child: Text(
                                          snapShot.data.details,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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