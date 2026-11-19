class CartItem {
  final String name;
  final String description;
  final String image;
  final int price;
  final String rating;
  final bool isVeg;
  int quantity;

  CartItem({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.isVeg,
    this.quantity = 1,
  });

  // Calculate total price for this item
  int get totalPrice => price * quantity;
}
