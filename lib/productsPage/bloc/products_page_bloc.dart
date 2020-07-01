import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonget/models/Product.dart';
import 'package:jsonget/productsPage/bloc/products_page_event.dart';
import 'package:jsonget/productsPage/bloc/products_page_state.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductsPageBloc extends Bloc<ProductsPageEvent, ProductsPageState> {
  int offset = 0, limit = 10;
  List<Product> productList = [];

  @override
  ProductsPageState get initialState => ProductsInit();

  void _getProducts() async {
    Response response;
    Dio dio = new Dio();
    response =  await dio.get(
        "http://mobile-test.devebs.net:5000/products?limit=$limit&offset=$offset");

    for (var i in response.data) {
      Product product = Product(i["id"], i["title"], i["short_description"],
          i["image"], i["price"], i["details"], false);
      productList.add(product);
    }
    offset += limit;
  }

  @override
  Stream<ProductsPageState> mapEventToState(ProductsPageEvent event) async* {
    if (event is LoadProducts) {
      _getProducts();

      // gives the state of loaded products
      yield ProductsLoaded();
    }
  }

//  void setFavourite(database) async {
//    WidgetsFlutterBinding.ensureInitialized();
//    database = openDatabase(
//      join(await getDatabasesPath(), 'favourites.db'),
//      onCreate: (db, version) {
//        return db.execute(
//          "CREATE TABLE products(id INTEGER PRIMARY KEY, title TEXT,  "
//          "imageUrl TEXT, price INTEGER, details TEXT)",
//        );
//      },
//      version: 1,
//    );
//  }
//
//  Future<void> insertProduct(Product product, database) async {
//    final Database db = await database;
//    await db.insert(
//      'products',
//      product.toMap(),
//      conflictAlgorithm: ConflictAlgorithm.replace,
//    );
//  }
//
//  Future<void> deleteProduct(Product product, database) async {
//    final db = await database;
//    await db.delete(
//      'products',
//      where: "id = ?",
//      whereArgs: [product.id],
//    );
//  }
//
//  Future<List<Product>> products(database) async {
//    final Database db = await database;
//
//    final List<Map<String, dynamic>> maps = await db.query('products');
//
//    return List.generate(maps.length, (i) {
//      return Product(
//          maps[i]['id'],
//          maps[i]['title'],
//          maps[i]['short_description'],
//          maps[i]['imageUrl'],
//          maps[i]['price'],
//          maps[i]['details']);
//    });
//  }
//
//  void printDb(database){
//    print(products(database));
//  }

  loadProducts() {
    add(LoadProducts());
  }

}
