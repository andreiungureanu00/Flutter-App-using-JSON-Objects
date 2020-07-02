import 'dart:async';
import 'dart:io' as io;
import 'package:jsonget/models/Product.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FavouriteSingleton {
  static Database _database;
  Product product;

  String table = 'product';
  String columnId = 'id';
  String columnTitle = 'title';
  String columnDescription = 'short_description';

  //String columnImage = 'imageUrl';
  String columnPrice = 'price';
  String columnDetails = 'details';
  String columnSale = 'sale_precent';

  static final FavouriteSingleton _singleton =
      new FavouriteSingleton._internal();

  factory FavouriteSingleton() {
    return _singleton;
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

  addToFavourite(Product product) {
    newProduct(product);

    //send notification to all screens that listen events
    _events.forEach((element) {
      element.onFavouriteAdded(product.id);
    });
  }

  removeFromFavourite(Product product) {
    deleteProduct(product.id);

    //send notification to all screens that listen events
    _events.forEach((element) {
      element.onFavouriteDeleted(product.id);
    });
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "favourite.db");
    var theDb = await openDatabase(path, version: 2, onCreate: _onCreate);
    return theDb;
  }

  Future<FutureOr<void>> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $table($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnDescription TEXT, imageUrl TEXT, $columnPrice INTEGER, $columnDetails TEXT, $columnSale INTEGER)',
    );
    print("Created tables");
  }

  Future<int> newProduct(Product product) async {
    Database db = await this.database;
    var res = await db.insert('$table', product.toMap());
    return res;
  }

  Future<int> updateProduct(Product product) async {
    final db = await this.database;
    var res = await db.update('$table', product.toMap(),
        where: "id = ?", whereArgs: [product.id]);
    return res;
  }

  Future<int> deleteProduct(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $table where $columnId = $id');
//    db.delete('products', where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Map<String, dynamic>>> getProductsList() async {
    Database db = await this.database;

//    var result = await db.rawQuery('SELECT * FROM products');
    var result = await db.query('$table');

    return result;
  }

  Future<List<Product>> getProducts() async {
    var productMapList =
        await getProductsList();
    int count = productMapList.length;

    List<Product> productList = List<Product>();
    for (int i = 0; i < count; i++) {
      productList.add(Product.fromMapObject(productMapList[i]));
    }

    return productList;
  }

//  Future<List<Product>> get_products() async {
//
//    Map<String, dynamic> todoMapList = (await get_products()) as Map<String, dynamic>; // Get 'Map List' from database
//    int count = todoMapList.length;
//
//    List<Product> products_list = List<Product>();
//    for (int i = 0; i < count; i++) {
//      products_list.add(Product.fromMapObject(todoMapList[i]));
//    }
//
//    return products_list;
//  }

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
    Map<String, dynamic> productMapList = (await getProducts())
        as Map<String, dynamic>; // Get 'Map List' from database
    int count = productMapList.length;

    List<Product> products_list = List<Product>();
    for (int i = 0; i < count; i++) {
      products_list.add(Product.fromMapObject(productMapList[i]));
    }

    //TODO verificam in products daca este un produs din products_list, si ii punem field isFavorite true sau false
    for (int i = 0; i < products.length; i++) {
      if (products[i].id == products_list[i].id) {
        products[i].isFavourite = true;
      } else {
        products[i].isFavourite = false;
      }
    }

    return products;
  }
}

abstract class FavouriteEvents {
  void onFavouriteAdded(int productId);

  void onFavouriteDeleted(int productId);
}
