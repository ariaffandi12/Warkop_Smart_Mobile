class ProductModel {
  final int id;
  final String name;
  final int price;
  final int stock;
  final String? imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      price: int.parse(json['price'].toString()),
      stock: int.parse(json['stock'].toString()),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
    };
  }
}
