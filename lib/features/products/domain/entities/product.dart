class Product {
  const Product({
    this.id,
    required this.name,
    this.description,
    required this.price,
    this.stock = 0,
    this.sku,
    this.category,
    this.imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  final int? id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? sku;
  final String? category;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isOutOfStock => stock <= 0;

  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? sku,
    String? category,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'sku': sku,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      sku: json['sku'] as String?,
      category: json['category'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Product &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            description == other.description &&
            price == other.price &&
            stock == other.stock &&
            sku == other.sku &&
            category == other.category &&
            imageUrl == other.imageUrl &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      price,
      stock,
      sku,
      category,
      imageUrl,
      createdAt,
      updatedAt,
    );
  }
}
