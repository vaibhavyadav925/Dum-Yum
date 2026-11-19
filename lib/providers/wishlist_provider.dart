import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  WishlistProvider._internal();

  static final WishlistProvider instance = WishlistProvider._internal();

  static const String _storageKey = 'dum_yani_wishlist';

  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  bool isWishlisted(String name) {
    return _items.any((item) => item['name'] == name);
  }

  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    if (savedData == null) return;

    try {
      final decoded = jsonDecode(savedData) as List;

      _items
        ..clear()
        ..addAll(decoded.map((item) => Map<String, dynamic>.from(item as Map)));

      notifyListeners();
    } catch (error) {
      debugPrint('Could not load wishlist: $error');
    }
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    final name = item['name']?.toString();

    if (name == null || name.isEmpty || isWishlisted(name)) {
      return;
    }

    _items.add(Map<String, dynamic>.from(item));

    await _saveWishlist();
    notifyListeners();
  }

  Future<void> removeItem(String name) async {
    _items.removeWhere((item) => item['name'] == name);

    await _saveWishlist();
    notifyListeners();
  }

  Future<void> toggleItem(Map<String, dynamic> item) async {
    final name = item['name']?.toString();

    if (name == null || name.isEmpty) return;

    if (isWishlisted(name)) {
      await removeItem(name);
    } else {
      await addItem(item);
    }
  }

  Future<void> clearWishlist() async {
    _items.clear();

    await _saveWishlist();
    notifyListeners();
  }

  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_storageKey, jsonEncode(_items));
  }
}
