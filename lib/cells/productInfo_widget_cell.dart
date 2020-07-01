
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsonget/models/Product.dart';

class ProductInfoWidgetCell extends StatefulWidget {

  final Product product;

  ProductInfoWidgetCell(this.product);

  @override
  ProductInfoWidgetCellState createState() => ProductInfoWidgetCellState();

}

class ProductInfoWidgetCellState extends State<ProductInfoWidgetCell> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          InkWell(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              height: 250,
              width: 330,
              child: new Image.network(
                  widget.product.imageUrl),
            ),
          ),
          InkWell(
            child: Container(
              height: 50,
              width: 400,
              margin: EdgeInsets.only(top: 24),
              child: Center(
                child: new Text(
                  widget.product.title,
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
                widget.product.short_description,
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
                widget.product.price.toString() +
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
                      widget.product.details,
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
    );
  }

}