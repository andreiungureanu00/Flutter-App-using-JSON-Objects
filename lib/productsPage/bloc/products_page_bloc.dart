import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:jsonget/models/Product.dart';
import 'package:jsonget/productsPage/bloc/products_page_event.dart';
import 'package:jsonget/productsPage/bloc/products_page_state.dart';

class ProductsPageBloc extends Bloc<ProductsPageEvent, ProductsPageState> {
  int offset = 0, limit = 5;
  List<Product> productList = [];

  @override
  ProductsPageState get initialState => ProductsInit();

  @override
  Stream<ProductsPageState> mapEventToState(ProductsPageEvent event) async* {
    if (event is LoadProducts) {
      await _getProducts();
      yield ProductsLoaded();
    }
  }

  _getProducts() async {
    var data = await http.get(
        "http://mobile-test.devebs.net:5000/products?limit=$limit&offset=$offset");

    var jsonData = json.decode(data.body);

    for (var i in jsonData) {
      Product product = Product(i["id"], i["title"], i["short_description"],
          i["image"], i["price"], i["details"]);
      productList.add(product);
    }
    offset += limit;
  }

  loadProducts() {
    add(LoadProducts());
  }
}
