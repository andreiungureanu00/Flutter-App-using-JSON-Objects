import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonget/cells/productInfo_widget_cell.dart';
import 'package:jsonget/database/favorite_singleton.dart';
import 'package:jsonget/models/Product.dart';
import 'package:jsonget/productInfoPage/bloc/products_info_bloc.dart';

import 'bloc/product_info_state.dart';

class ProductInfoScreen extends StatefulWidget {
  ProductInfoScreen({Key key, this.title, this.productId}) : super(key: key);

  final String title;
  final int productId;

  @override
  ProductInfoScreenState createState() => ProductInfoScreenState(productId);
}

class ProductInfoScreenState extends State<ProductInfoScreen> with FavouriteEvents{
  Product product;
  int productId;
  ProductInfoBloc _productBloc;

  ProductInfoScreenState(this.productId);

  @override
  void initState() {
    _productBloc = ProductInfoBloc(productId);
    // initial load
    _productBloc.loadProduct();
    FavouriteSingleton().addListener(this);
    super.initState();
  }

  @override
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
          child:
//            FutureBuilder(
//              future: getProduct(),
//              // in snapShot will be available the result of getProducts
//              builder: (BuildContext context, AsyncSnapshot snapShot) {
//                if (snapShot.data == null) {
//                  return Container(
//                    child: Center(
//                        child: new Text(
//                          "Loading ...",
//                          textAlign: TextAlign.center,
//                        )
//                    ),
//                  );
//                } else {
//                  return Material(
//                    color: Colors.white,
//                      child: SingleChildScrollView(
//                        child: ConstrainedBox(
//                          constraints: BoxConstraints(),
//                          child: ProductInfoWidgetCell(product)
//                        ),
//                      ),
//                    );
//                }
//              },
//            ),
              BlocBuilder<ProductInfoBloc, ProductInfoState>(
                  bloc: _productBloc,
                  builder: (context, state) {
                    if (_productBloc.product != null) {
                      return Material(
                        color: Colors.white,
                        child: Container(
                        child: SingleChildScrollView(
                            child: ProductInfoWidgetCell(_productBloc.product)),
                      ));
                    } else {
                      return Container();
                    }
                  })),
    );
  }

  @override
  void onFavouriteAdded(int productId) {
    _productBloc.onFavouriteAdded(productId);
  }

  @override
  void onFavouriteDeleted(int productId) {
   _productBloc.onFavouriteRemoved(productId);
  }

}
