import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonget/models/Product.dart';
import 'package:jsonget/productInfoPage/bloc/product_info_event.dart';
import 'package:jsonget/productInfoPage/bloc/product_info_state.dart';
import 'package:dio/dio.dart';

class ProductInfoBloc extends Bloc<ProductInfoEvent, ProductInfoState> {

  @override
  ProductInfoState get initialState => ProductInit();

  Product product;

  Future<void> getProduct(int productId) async {
    Response response;
    Dio dio = new Dio();
    String url = "http://mobile-test.devebs.net:5000/product?id=";

    url = url + productId.toString();
    response = await dio.get(url);
    product = Product(response.data['id'], response.data["title"], response.data["short_description"],
        response.data["image"], response.data["price"], response.data["details"], false);

  }

  @override
  Stream<ProductInfoState> mapEventToState(ProductInfoEvent event) async* {
    if (event is LoadProduct) {
      await getProduct(product.id);

      yield ProductLoaded();
    }
  }

  loadProduct() {
    add(LoadProduct());
  }

}