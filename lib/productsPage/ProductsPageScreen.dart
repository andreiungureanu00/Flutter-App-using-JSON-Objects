import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonget/cells/product_widget_cell.dart';
import 'package:jsonget/productsPage/bloc/products_page_bloc.dart';
import 'package:jsonget/productsPage/bloc/products_page_state.dart';

class ProductsPageScreen extends StatefulWidget {
  ProductsPageScreen({Key key, this.title, this.database}) : super(key: key);

  final String title;
  final database;

  @override
  _ProductsPageScreenState createState() => _ProductsPageScreenState(database);
}

class _ProductsPageScreenState extends State<ProductsPageScreen> {

  ScrollController controller;
  ProductsPageBloc _bloc;
  final database;

  _ProductsPageScreenState(this.database);

  @override
  void initState() {
    _bloc = ProductsPageBloc(database);
    controller = new ScrollController();

    // initial load
    _bloc.loadProducts();
    super.initState();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        _bloc.loadProducts();
      }
    });
  }

  void dispose() {
    controller.dispose();
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
            BlocBuilder<ProductsPageBloc, ProductsPageState>(
                bloc: _bloc,
                builder: (context, state) {
                  return Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: _bloc.productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductWidgetCell(_bloc.productList[index], _bloc);
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
