import 'dart:async';
import 'dart:io' as io;
import 'package:jsonget/models/Product.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FavouriteSingleton {
  static Database _database;
  Product product;

  static final FavouriteSingleton _singleton =
      new FavouriteSingleton._internal();

  factory FavouriteSingleton() {
    return _singleton;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "favourites.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  Future<FutureOr<void>> _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE products(id INTEGER PRIMARY KEY, title TEXT, short_description TEXT "
      "imageUrl TEXT, price INTEGER, details TEXT)",
    );
    print("Created tables");
  }

  newProduct(Product product) async {
    var db = await database;
    var res = await db.insert("Product", product.toMap());
    return res;
  }

  updateProduct(Product product) async {
    final db = await database;
    var res = await db.update("Client", product.toMap(),
        where: "id = ?", whereArgs: [product.id]);
    return res;
  }

  Future<List<Product>> get_products() async {

    Map<String, dynamic> todoMapList = (await get_products()) as Map<String, dynamic>; // Get 'Map List' from database
    int count = todoMapList.length;

    List<Product> products_list = List<Product>();
    for (int i = 0; i < count; i++) {
      products_list.add(Product.fromMapObject(todoMapList[i]));
    }

    return products_list;
  }

//  Future<List<Product>> products() async {
//    final Database db = await database;
//    final List<Map<String, dynamic>> maps = await db.query('products');
//
//    return List.generate(maps.length, (i) {
//      return Product(id: maps[i]['id'],
//          'title': maps[i]['title'],
//          short_description: maps[i]['short_description'],
//          imageUrl: maps[i]['imageUrl'],
//          price: maps[i]['price'],
//          details: maps[i]['details']
//      );
//    });
//  }

  Future<List<Product>> productsMapToFavourite(List<Product> products) async {
    Map<String, dynamic> todoMapList = (await get_products()) as Map<String, dynamic>; // Get 'Map List' from database
    int count = todoMapList.length;

    List<Product> products_list = List<Product>();
    for (int i = 0; i < count; i++) {
      products_list.add(Product.fromMapObject(todoMapList[i]));
    }

    //TODO verificam in products daca este un produs din products_list, si ii punem field isFavorite true sau false
    for (int i = 0; i < products.length; i++) {
      if (products[i].id == products_list[i].id){
        products[i].isFavourite = true;
      }
      else {
        products[i].isFavourite = false;
      }
    }

    return products;
  }


  deleteProduct(int id) async {
    final db = await _database;
    db.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  FavouriteSingleton._internal();

  List<FavouriteEvents> _events = [];

  //add on init screen
  addListener(FavouriteEvents event) {
    _events.add(event);
  }

  //remove on delete screen
  removeListener(FavouriteEvents event) {
    _events.remove(event);
  }

  addToFavourite(int productId) {
    newProduct(product);

    //send notification to all screens that listen events
    _events.forEach((element) {
      element.onFavouriteAdded(productId);
    });
  }

  removeFromFavourite(int productId) {
    deleteProduct(productId);

    //send notification to all screens that listen events
    _events.forEach((element) {
      element.onFavouriteDeleted(productId);
    });
  }
}

abstract class FavouriteEvents {
  void onFavouriteAdded(int productId);
  void onFavouriteDeleted(int productId);
}
