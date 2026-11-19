import 'package:flutter/foundation.dart';

import '../models/cart_model.dart';
import '../models/order_model.dart';

/// In-memory cart for the Dum Yani customer app. Order history is managed separately.
class CartProvider extends ChangeNotifier {
  CartProvider._();
  static final CartProvider instance = CartProvider._();

  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold<int>(0, (sum, item) => sum + item.quantity);
  int get subtotal => _items.fold<int>(0, (sum, item) => sum + item.totalPrice);

  void addItem({
    required String name,
    required String description,
    required String image,
    required int price,
    required String rating,
    required bool isVeg,
    int quantity = 1,
  }) {
    if (quantity <= 0) return;
    final index = _items.indexWhere((item) => item.name == name);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          name: name,
          description: description,
          image: image,
          price: price,
          rating: rating,
          isVeg: isVeg,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    final found = _findItem(item);
    if (found == null) return;
    found.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    final found = _findItem(item);
    if (found == null) return;
    if (found.quantity > 1) {
      found.quantity--;
    } else {
      _items.remove(found);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.removeWhere((entry) => identical(entry, item));
    notifyListeners();
  }

  void clearCart() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }

  CartItem? _findItem(CartItem item) {
    for (final entry in _items) {
      if (identical(entry, item)) return entry;
    }
    return null;
  }

  /// Re-adds order lines using the current menu catalogue and current prices.
  int addOrderItems(Iterable<OrderItem> orderItems) {
    var addedCount = 0;
    for (final orderItem in orderItems) {
      final product = _catalogEntry(orderItem.name);
      if (product == null || orderItem.quantity <= 0) continue;
      addItem(
        name: product.name,
        description: product.description,
        image: product.image,
        price: product.price,
        rating: product.rating,
        isVeg: product.isVeg,
        quantity: orderItem.quantity,
      );
      addedCount++;
    }
    return addedCount;
  }

  _CartCatalogEntry? _catalogEntry(String name) {
    const catalog = <_CartCatalogEntry>[
      _CartCatalogEntry(
        name: 'Chicken Biryani, Bone-in · Supertaster (500 g)',
        description: '2 leg pieces + 1 egg, long-grain basmati, sealed and cooked on dum.',
        image: 'assets/images/biryani/chicken_biryani.jpg',
        price: 549,
        rating: '4.9',
        isVeg: false,
      ),
      _CartCatalogEntry(
        name: 'Chicken Biryani, Boneless · Taster (350 g)',
        description: '80 g thigh meat + 1 egg, long-grain basmati, sealed and cooked on dum.',
        image: 'assets/images/biryani/chicken_biryani.jpg',
        price: 200,
        rating: '4.8',
        isVeg: false,
      ),
      _CartCatalogEntry(
        name: 'Paneer Biryani · Taster (350 g)',
        description: '100 g full-cream paneer, long-grain basmati, sealed and cooked on dum.',
        image: 'assets/images/biryani/veg_biryani.jpg',
        price: 200,
        rating: '4.8',
        isVeg: true,
      ),
      _CartCatalogEntry(
        name: 'Chicken Biryani, Bone-in · Taster (350 g)',
        description: '1 leg piece + 1 egg, long-grain basmati, sealed and cooked on dum.',
        image: 'assets/images/biryani/chicken_biryani.jpg',
        price: 180,
        rating: '4.8',
        isVeg: false,
      ),
      _CartCatalogEntry(
        name: 'Chicken Biryani, Boneless · Supertaster (500 g)',
        description: '120 g thigh meat + 1 egg, long-grain basmati, sealed and cooked on dum.',
        image: 'assets/images/biryani/chicken_biryani.jpg',
        price: 280,
        rating: '4.9',
        isVeg: false,
      ),
      _CartCatalogEntry(
        name: 'Mutton Biryani - Bulk Order (5 kg)',
        description: 'A 5 kg handi of mutton dum biryani for parties and family gatherings.',
        image: 'assets/images/biryani/mutton_biryani.jpg',
        price: 5000,
        rating: '4.9',
        isVeg: false,
      ),
      _CartCatalogEntry(
        name: 'Soya Biryani · Taster (350 g)',
        description: '100 g high-protein soya chunks, long-grain basmati, sealed and cooked on dum.',
        image: 'assets/images/biryani/veg_biryani.jpg',
        price: 150,
        rating: '4.7',
        isVeg: true,
      ),
      _CartCatalogEntry(
        name: 'Egg Biryani · Taster (350 g)',
        description: '2 high-protein desi eggs, long-grain basmati, sealed and cooked on dum.',
        image: 'assets/images/biryani/egg_biryani.jpg',
        price: 120,
        rating: '4.7',
        isVeg: false,
      ),
      // Legacy menu names retained so older saved orders can still be reordered.
      _CartCatalogEntry(
        name: 'Hyderabadi Chicken Biryani',
        description: 'Authentic dum cooked chicken biryani.',
        image: 'assets/images/biryani/chicken_biryani.jpg',
        price: 249,
        rating: '4.8',
        isVeg: false,
      ),
      _CartCatalogEntry(
        name: 'Royal Mutton Biryani',
        description: 'Tender mutton with aromatic basmati rice.',
        image: 'assets/images/biryani/mutton_biryani.jpg',
        price: 329,
        rating: '4.9',
        isVeg: false,
      ),
      _CartCatalogEntry(
        name: 'Veg Dum Biryani',
        description: 'Fresh vegetables and fragrant spices.',
        image: 'assets/images/biryani/veg_biryani.jpg',
        price: 189,
        rating: '4.7',
        isVeg: true,
      ),
      _CartCatalogEntry(
        name: 'Egg Biryani',
        description: 'Delicious dum biryani with boiled eggs.',
        image: 'assets/images/biryani/egg_biryani.jpg',
        price: 199,
        rating: '4.6',
        isVeg: false,
      ),
    ];
    for (final product in catalog) {
      if (product.name == name) return product;
    }
    return null;
  }
}

class _CartCatalogEntry {
  final String name, description, image, rating;
  final int price;
  final bool isVeg;
  const _CartCatalogEntry({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.isVeg,
  });
}
