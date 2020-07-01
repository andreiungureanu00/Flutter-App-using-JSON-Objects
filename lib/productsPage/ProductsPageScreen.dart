import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonget/cells/product_widget_cell.dart';
import 'package:jsonget/database/favorite_singleton.dart';
import 'package:jsonget/productsPage/bloc/products_page_bloc.dart';
import 'package:jsonget/productsPage/bloc/products_page_state.dart';

class ProductsPageScreen extends StatefulWidget {
  ProductsPageScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProductsPageScreenState createState() => _ProductsPageScreenState();
}

class _ProductsPageScreenState extends State<ProductsPageScreen> with FavouriteEvents{

  ScrollController controller;
  ProductsPageBloc _bloc;

  @override
  void initState() {
    _bloc = ProductsPageBloc();
    controller = new ScrollController();

    // initial load
    _bloc.loadProducts();
    FavouriteSingleton().initDb();
    FavouriteSingleton().addListener(this);
    super.initState();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        _bloc.loadProducts();
      }
    });
  }

  void dispose() {
    controller.dispose();
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
      ),
      actions: [
        Row(
          children: [
            Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            SizedBox(
              width: 5,
            )
          ],
        )
      ],),
      body: Column(
          children: <Widget>[
            BlocBuilder<ProductsPageBloc, ProductsPageState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (_bloc.productList != null) {
                    return Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: _bloc.productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ProductWidgetCell(_bloc.productList[index]);
                        },
                      ),
                    );
                  }
                  else {
                    return CircularProgressIndicator(
                    );
                  }
                }),
          ],
        ),
    );
  }

  @override
  void onFavouriteAdded(int productId) {
    _bloc.onFavouriteAdded(productId);
  }

  @override
  void onFavouriteDeleted(int productId) {
    _bloc.onFavouriteRemoved(productId);
  }
}
