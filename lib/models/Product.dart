
class Product {
  final int id;
  final String title;
  // ignore: non_constant_identifier_names
  final String short_description;
  final String imageUrl;
  final int price;
  final String details;

  Product(this.id, this.title, this.short_description, this.imageUrl, this.price, this.details);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'short_description': short_description,
      'imageUrl': imageUrl,
      'price': price,
      'details': details
    };
  }

  String toString() {
    return 'Product{id: $id, title: $title, short_description: $short_description, imageUrl: $imageUrl,'
        'price: $price,  details: $details}';
  }

}