import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jsonget/Product.dart';
import 'package:jsonget/HomePage.dart';

class ProductInfo extends StatefulWidget {

  final int productId;

  ProductInfo({Key key, this.title, @required this.productId}) : super(key: key);

  final String title;

  @override
  ProductInfoState createState() => ProductInfoState(productId);
}

class ProductInfoState extends State<ProductInfo> {

  Product product;
  int productId;


  ProductInfoState(this.productId);

  Future<Product> getProduct() async {
    String url = "http://mobile-test.devebs.net:5000/product?id=";

    url = url + 1.toString();
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
                  return Container(
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
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => MyHomePage(),
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
                                snapShot.data.title,
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
                                builder: (context) => MyHomePage(),
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
                              snapShot.data.short_description,
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
                          height: 25,
                          width: 400,
                          margin: EdgeInsets.only(top: 30, bottom: 45),
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
                        )
                      ],
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