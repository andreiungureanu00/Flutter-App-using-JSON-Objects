import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonget/database/favorite_singleton.dart';
import 'package:jsonget/models/Product.dart';
import 'package:jsonget/productInfoPage/bloc/product_info_event.dart';
import 'package:jsonget/productInfoPage/bloc/product_info_state.dart';
import 'package:dio/dio.dart';

class ProductInfoBloc extends Bloc<ProductInfoEvent, ProductInfoState> {
  Product product;
  int productId;

  ProductInfoBloc(this.productId);

  @override
  ProductInfoState get initialState => ProductInit();

  Future<void> getProduct(int productId) async {
    Response response;
    Dio dio = new Dio();
    String url = "http://mobile-test.devebs.net:5000/product?id=";
    url = url + productId.toString();
    response = await dio.get(url);
    product = Product(
        response.data['id'],
        response.data["title"],
        response.data["short_description"],
        response.data["image"],
        response.data["price"],
        response.data["details"],
        response.data["sale_precent"],
        false);

    await FavouriteSingleton().productMapToFavourite(product);

  }

  @override
  Stream<ProductInfoState> mapEventToState(ProductInfoEvent event) async* {
    if (event is LoadProduct) {
      await getProduct(productId);
      yield ProductLoaded();
    }
    if (event is ReloadProduct) {
      yield ProductLoaded();
    }
  }

  onFavouriteAdded(int productID) {
    if (product.id == productID) {
      product.isFavourite = true;
      return;
    }
    add(ReloadProduct());
  }

  onFavouriteRemoved(int productID) {
    if (product.id == productID) {
      product.isFavourite = false;
      return;
    }
    add(ReloadProduct());
  }

  loadProduct() {
    add(LoadProduct());
  }
}
