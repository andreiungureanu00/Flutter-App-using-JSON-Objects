
abstract class FavouritesEvent extends Object {
  const FavouritesEvent();
}

class LoadFavouriteProducts extends FavouritesEvent {}
class ReloadFavouriteProducts extends FavouritesEvent {}