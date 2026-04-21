class User {
  final String name;
  final String greeting;
  final String profileImage;

  User({
    required this.name,
    required this.greeting,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      greeting: json['greeting'],
      profileImage: json['profile_image'],
    );
  }
}

class SpecialOffer {
  final String id;
  final String discount;
  final String title;
  final String description;
  final String image;

  SpecialOffer({
    required this.id,
    required this.discount,
    required this.title,
    required this.description,
    required this.image,
  });

  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    return SpecialOffer(
      id: json['id'],
      discount: json['discount'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }
}

class Category {
  final String id;
  final String name;
  final String icon;

  Category({required this.id, required this.name, required this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name'], icon: json['icon']);
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final double rating;
  final int reviews;
  final String image;
  final bool isFavorite;
  final String category;
  final String description;
  final List<String> sizes;
  final List<int> colors; // Hex values or names

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.isFavorite,
    required this.category,
    this.description =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.",
    this.sizes = const ["39", "40", "41", "42"],
    this.colors = const [0xFF4F738E, 0xFF8B5E52, 0xFF9E9E9E],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      image: json['image'],
      isFavorite: json['is_favorite'],
      category: json['category'],
      description:
          json['description'] ??
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.",
      sizes: json['sizes'] != null
          ? List<String>.from(json['sizes'])
          : const ["39", "40", "41", "42"],
      colors: json['colors'] != null
          ? List<int>.from(json['colors'])
          : const [0xFF4F738E, 0xFF8B5E52, 0xFF9E9E9E],
    );
  }
}
