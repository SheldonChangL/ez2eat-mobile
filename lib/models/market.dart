class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });
}

class Market {
  final String id;
  final String name;
  final String location;
  final String hours;
  final String image;
  final String description;
  final List<Product> products;

  const Market({
    required this.id,
    required this.name,
    required this.location,
    required this.hours,
    required this.image,
    required this.description,
    required this.products,
  });
}
