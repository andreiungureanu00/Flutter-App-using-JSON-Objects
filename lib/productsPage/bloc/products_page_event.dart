
abstract class ProductsPageEvent extends Object {
  const ProductsPageEvent();
}

class LoadProducts extends ProductsPageEvent {}
class ReloadProducts extends ProductsPageEvent {}