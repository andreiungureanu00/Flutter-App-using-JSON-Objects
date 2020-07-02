import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsonget/models/Product.dart';

import '../productInfoPage/ProductInfoScreen.dart';

class ProductWidgetCell extends StatefulWidget {
  final Product product;

  ProductWidgetCell(this.product);

  @override
  ProductWidgetCellState createState() => ProductWidgetCellState();
}

class ProductWidgetCellState extends State<ProductWidgetCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Column(
          children: <Widget>[
            InkWell(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                height: 250,
                width: 330,
                child: new Image.network(
                    widget.product.imageUrl),//snapShot.data[index].imageUrl),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => ProductInfoScreen(productId: widget.product.id),
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
                    widget.product.title,
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
                    builder: (context) => ProductInfoScreen(productId: widget.product.id),
                  ));
                  //debugPrint(snapShot.data[index].toString());
                }
              },
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
          ],
        ),
      )
    );
  }
}
