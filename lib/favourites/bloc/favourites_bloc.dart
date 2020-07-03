
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonget/database/favorite_singleton.dart';
import 'package:jsonget/models/Product.dart';
import 'package:jsonget/productsPage/bloc/products_page_event.dart';
import 'favourites_event.dart';
import 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  int offset = 0, limit = 10;
  List<Product> productList;

  @override
  FavouritesState get initialState => FavouriteProductsInit();

  Future<List<Product>> getProductsFromDb() async {

    productList = [];
    productList = await FavouriteSingleton().getProducts();

    return productList;
  }

  @override
  Stream<FavouritesState> mapEventToState(FavouritesEvent event) async* {
    if (event is LoadFavouriteProducts) {
      getProductsFromDb();
      // gives the state of loaded products
      yield FavouriteProductsLoaded();
    }
    if(event is ReloadFavouriteProducts){
      yield FavouriteProductsReloaded();
    }
  }

  loadFavouriteProducts() {
    add(LoadFavouriteProducts());
  }

  onFavouriteAdded(int productID){
    productList.forEach((element) {
      if(element.id == productID){
        element.isFavourite = true;
        return;
      }
    });
    add(ReloadFavouriteProducts());
  }

  onFavouriteRemoved(int productID){
    productList.forEach((element) {
      if(element.id == productID){
        element.isFavourite = false;
        return;
      }
    });
    add(ReloadFavouriteProducts());
  }
}
