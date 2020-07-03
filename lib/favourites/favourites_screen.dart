import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonget/cells/favorite_product_widget_cell.dart';
import 'package:jsonget/cells/productInfo_widget_cell.dart';
import 'dart:async';
import 'package:jsonget/database/favorite_singleton.dart';
import 'package:jsonget/favourites/bloc/favourites_bloc.dart';
import 'package:jsonget/favourites/bloc/favourites_state.dart';
import 'package:jsonget/models/Product.dart';
import 'package:jsonget/productInfoPage/ProductInfoScreen.dart';
import 'package:jsonget/productsPage/bloc/products_page_bloc.dart';
import 'package:jsonget/productsPage/bloc/products_page_state.dart';


class FavouritesPageScreen extends StatefulWidget {
  FavouritesPageScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FavouritesPageScreenState createState() => _FavouritesPageScreenState();
}

class _FavouritesPageScreenState extends State<FavouritesPageScreen> with FavouriteEvents {

  ScrollController controller;
  List<Product> products;
  FavouritesBloc _favouritesBloc;

  @override
  void initState() {
    controller = new ScrollController();
    _favouritesBloc = FavouritesBloc();
    _favouritesBloc.loadFavouriteProducts();
    super.initState();

  }

//  Future<List<Product>> getProductsFromDb() async {
//
//    List<Product> products = [];
//    products = await FavouriteSingleton().getProducts();
//
//    return products;
//  }

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
//            FutureBuilder(
//              future: getProductsFromDb(),
//              builder: (BuildContext context, AsyncSnapshot snapShot) {
//                if (snapShot.data == null) {
//                  return Container(
//                    child: Center(child: Text("Loading...")),
//                  );
//                } else {
//                  return Expanded(
//                    child: SizedBox(
//                      height: 200.0,
//                      child: new ListView.builder(
//                        itemCount: snapShot.data.length,
//                        itemBuilder: (BuildContext context, int index) {
//                          return FavoriteProductInfoWidgetCell(snapShot.data[index]);
//                        },
//                      ),
//                    ),
//                  );
//                }
//              },
//            ),
            BlocBuilder<FavouritesBloc, FavouritesState>(
                bloc: _favouritesBloc,
                builder: (context, state) {
                  if (_favouritesBloc.productList != null) {
                    return Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: _favouritesBloc.productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FavoriteProductWidgetCell(_favouritesBloc.productList[index]);
                        },
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                })
          ],
        ),
      ),
    );
  }

  @override
  void onFavouriteAdded(int productId) {
   _favouritesBloc.onFavouriteAdded(productId);
  }

  @override
  void onFavouriteDeleted(int productId) {
    _favouritesBloc.onFavouriteRemoved(productId);
  }
}