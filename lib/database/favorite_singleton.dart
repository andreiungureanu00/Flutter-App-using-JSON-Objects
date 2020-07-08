import 'dart:async';
import 'dart:io' as io;
import 'package:jsonget/models/Product.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FavouriteSingleton {
  static Database _database;
  Product product;
  List<Product> productList;

  String table = 'product';
  String columnId = 'id';
  String columnTitle = 'title';
  String columnDescription = 'short_description';
  String columnImage = 'imageUrl';
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
    String path = join(documentsDirectory.path, "favouriteproducts.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $table($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnDescription TEXT,'
          ' $columnImage TEXT, $columnPrice INTEGER, $columnDetails TEXT, $columnSale INTEGER)',
    );
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
    var result = await db.query('$table');

    return result;
  }

  Future<List<Product>> getProducts() async {
    var productMapList = await getProductsList();
    int count = productMapList.length;

    List<Product> productList = List<Product>();
    for (int i = 0; i < count; i++) {
      productList.add(Product.fromMapObject(productMapList[i]));
    }

    return productList;
  }

  Future<List<Product>> productsMapToFavourite(List<Product> products) async {
    var productMapList = await getProductsList();
    int count = productMapList.length;

    productList = List<Product>();
    productList = [];
    for (int i = 0; i < count; i++) {
      productList.add(Product.fromMapObject(productMapList[i]));
    }

    //TODO verificam in products daca este un produs din products_list, si ii punem field isFavorite true sau false
    for (int i = 0; i < products.length; i++) {
      for (int j = 0; j < productList.length; j++) {
        if (products[i].id == productList[j].id) {
          products[i].isFavourite = true;
        }
      }
    }

    return products;
  }

  Future<void> productMapToFavourite(Product product) async {
    var productMapList = await getProductsList();
    int count = productMapList.length;

    List<Product> productList = List<Product>();
    for (int i = 0; i < count; i++) {
      productList.add(Product.fromMapObject(productMapList[i]));
    }

    for (int i = 0; i < count; i++) {
      if (product.id == productList[i].id){
        product.isFavourite = true;
        break;
      }
      else {
        product.isFavourite = false;
      }
    }
  }
}

abstract class FavouriteEvents {
  void onFavouriteAdded(int productId);
  void onFavouriteDeleted(int productId);
}
