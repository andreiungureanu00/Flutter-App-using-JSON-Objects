import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jsonget/listItem/listItem.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController controller;
  int top, bottom;
  int indexList;

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
        .get("http://mobile-test.devebs.net:5000/products?limit=10&offset=0");

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
            ListItem(),
            RaisedButton(
              child: Visibility(
                child: Text("Next Page"),
                maintainState: true,
                visible: true,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SecondPage(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
            ListItem(),
            RaisedButton(
              child: Visibility(
                child: Text("Previous Page"),
                maintainState: true,
                visible: true,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SecondPage(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductInfo extends StatefulWidget {

  final int indexList;

  ProductInfo({Key key, this.title, @required this.indexList}) : super(key: key);

  final String title;

  @override
  ProductInfoState createState() => ProductInfoState();
}

class ProductInfoState extends State<ProductInfo> {

  Product product;

  Future<Product> getProduct() async {
    String url = "http://mobile-test.devebs.net:5000/product?id=";
    url = url + 2.toString();


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

class Product {
  final int id;
  final String title;
  // ignore: non_constant_identifier_names
  final String short_description;
  final String imageUrl;
  final int price;
  final String details;

  Product(
      this.id, this.title, this.short_description, this.imageUrl, this.price, this.details);
}
