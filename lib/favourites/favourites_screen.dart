import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonget/cells/favorite_product_widget_cell.dart';
import 'package:jsonget/database/favorite_singleton.dart';
import 'package:jsonget/favourites/bloc/favourites_bloc.dart';
import 'package:jsonget/favourites/bloc/favourites_state.dart';
import 'package:jsonget/models/Product.dart';

class FavouritesPageScreen extends StatefulWidget {
  FavouritesPageScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FavouritesPageScreenState createState() => _FavouritesPageScreenState();
}

class _FavouritesPageScreenState extends State<FavouritesPageScreen> with FavouriteEvents {

  List<Product> products;
  FavouritesBloc _favouritesBloc;

  @override
  void initState() {
    _favouritesBloc = FavouritesBloc();
    _favouritesBloc.loadFavouriteProducts();
    FavouriteSingleton().addListener(this);
    super.initState();
  }

  void dispose() {
    FavouriteSingleton().removeListener(this);
    super.dispose();
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
            BlocBuilder<FavouritesBloc, FavouritesState>(
                bloc: _favouritesBloc,
                builder: (context, state) {
                  if (_favouritesBloc.productList != null) {
                    return Expanded(
                      child: ListView.builder(
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