import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jsonget/Product.dart';
import 'package:jsonget/ProductInfo.dart';

class ListItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListItemState();
  }
}

class ListItemState extends State<ListItem> {

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
      body: Center(
        child: FutureBuilder(
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
                                  builder: (context) => ProductInfo(indexList: null,),
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
                                    builder: (context) => ProductInfo(indexList: null,),
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
      ),
    );
  }

}
