
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsonget/database/favorite_singleton.dart';
import 'package:jsonget/models/Product.dart';

import '../productInfoPage/ProductInfoScreen.dart';

class ProductWidgetCell extends StatefulWidget {
  final Product product;

  ProductWidgetCell(this.product);

  @override
  ProductWidgetCellState createState() => ProductWidgetCellState();
}

class ProductWidgetCellState extends State<ProductWidgetCell> {

  int tapCounter;

  ProductWidgetCellState(){
    tapCounter = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              height: 250,
              width: 330,
              child: new Image.network(
                  widget.product.imageUrl), //snapShot.data[index].imageUrl),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProductInfoScreen(productId: widget.product.id),
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProductInfoScreen(productId: widget.product.id),
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
            margin: EdgeInsets.only(top: 10),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.product.sale_precent > 0
                        ? (widget.product.price *
                                    (100 - widget.product.sale_precent) ~/
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
                    widget.product.price.toString() + '€',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: widget.product.sale_precent > 0
                            ? Color(0xff7F7F7F)
                            : Color(0xff0101DF),
                        decoration: widget.product.sale_precent > 0
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontSize: widget.product.sale_precent > 0 ? 18 : 23,
                        fontFamily: 'RobotMono'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 35,
            width: 400,
            margin: EdgeInsets.only(top: 10, bottom: 45),
            child: Center(
              child: Center(
                  child: InkWell(
                child: Icon(
                  Icons.favorite,
                  size: 24.0,
                  color: widget.product.isFavourite ? Colors.red : Colors.black26,
                ),
                onTap: ()  {
                  tapCounter++;
                  if (tapCounter % 2 == 1) {
                    widget.product.isFavourite = true;
                    FavouriteSingleton().addToFavourite(widget.product);
                    debugPrint("Am adaugat la favourites");
                  }
                  else {
                    widget.product.isFavourite = false;
                    FavouriteSingleton().removeFromFavourite(widget.product);
                    debugPrint("Am sters de la favourites");
                  }
                },
              )),
            ),
          )
        ],
      ),
    );
  }
}
