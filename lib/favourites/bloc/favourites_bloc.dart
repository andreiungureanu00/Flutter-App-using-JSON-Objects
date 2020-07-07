import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonget/database/favorite_singleton.dart';
import 'package:jsonget/models/Product.dart';
import 'favourites_event.dart';
import 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  int offset = 0, limit = 10;
  List<Product> productList;

  @override
  FavouritesState get initialState => FavouriteProductsInit();

  @override
  Stream<FavouritesState> mapEventToState(FavouritesEvent event) async* {
    if (event is LoadFavouriteProducts) {
      getProductsFromDb();
      yield FavouriteProductsLoaded();
    }
    if (event is ReloadFavouriteProducts) {
      getProductsFromDb();
      yield FavouriteProductsReloaded();
    }
  }

  getProductsFromDb() async {
    productList = [];
    productList = await FavouriteSingleton().getProducts();

  }

  loadFavouriteProducts() {
    add(LoadFavouriteProducts());
  }

  onFavouriteAdded(int productID) {
    var product = productList.firstWhere((element) => element.id == productID);
    product.isFavourite = true;
   /* productList.forEach((element) {
      if (element.id == productID) {
        element.isFavourite = true;
        return;
      }
    });*/
    add(ReloadFavouriteProducts());
  }

  onFavouriteRemoved(int productID) {
    debugPrint("FavoritesRemove bloc onFavouriteRemoved ");

    productList.forEach((element) {
      if (element.id == productID) {
        element.isFavourite = false;
        return;
      }
    });
    add(LoadFavouriteProducts());
  }
}
