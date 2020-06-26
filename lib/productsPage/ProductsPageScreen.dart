import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonget/cells/product_widget_cell.dart';
import 'package:jsonget/productsPage/bloc/products_page_bloc.dart';
import 'package:jsonget/productsPage/bloc/products_page_state.dart';

class ProductsPageScreen extends StatefulWidget {
  ProductsPageScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProductsPageScreenState createState() => _ProductsPageScreenState();
}

class _ProductsPageScreenState extends State<ProductsPageScreen> {
  ScrollController controller;
  ProductsPageBloc _bloc;

  @override
  void initState() {
    _bloc = ProductsPageBloc();
    _bloc.loadProducts();
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
            BlocBuilder<ProductsPageBloc, ProductsPageState>(
                bloc: _bloc,
                builder: (context, state) {
                  return Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: _bloc.productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductWidgetCell(_bloc.productList[index]);
                      },
                    ),
                  );
                }),
            RaisedButton(
              child: Visibility(
                child: Text("Next Page"),
                maintainState: true,
                visible: true,
              ),
              color: Colors.white,
              onPressed: () {
                _bloc.loadProducts();
              },
            ),
          ],
        ),
      ),
    );
  }
}
