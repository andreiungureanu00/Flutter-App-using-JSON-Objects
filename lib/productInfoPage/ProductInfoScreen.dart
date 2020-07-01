import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:jsonget/cells/productInfo_widget_cell.dart';
import 'dart:convert';
import 'package:jsonget/models/Product.dart';

class ProductInfoScreen extends StatefulWidget {

  ProductInfoScreen({Key key, this.title, this.productId}) : super(key: key);

  final String title;
  final int productId;

  @override
  ProductInfoScreenState createState() => ProductInfoScreenState(productId);
}

class ProductInfoScreenState extends State<ProductInfoScreen> {

  Product product;
  int productId;

  ProductInfoScreenState(this.productId);

  Future<Product> getProduct() async {
    Response response;
    Dio dio = new Dio();
    String url = "http://mobile-test.devebs.net:5000/product?id=";

    url = url + productId.toString();
    response = await dio.get(url);
    product = Product(response.data['id'], response.data["title"], response.data["short_description"],
        response.data["image"], response.data["price"], response.data["details"], false);

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
                    color: Colors.white,
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(),
                          child: ProductInfoWidgetCell(product)
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