import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderProvider._() {
    _ready = _loadOrders();
  }

  static final OrderProvider instance = OrderProvider._();
  static const String _storageKey = 'dum_yani_saved_orders';

  final List<CustomerOrder> _orders = [];
  late final Future<void> _ready;

  List<CustomerOrder> get orders => List.unmodifiable(_orders);
  Future<void> get ready => _ready;

  Future<void> _loadOrders() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedData = preferences.getString(_storageKey);
      if (savedData == null || savedData.isEmpty) return;

      final decoded = jsonDecode(savedData) as List<dynamic>;
      _orders
        ..clear()
        ..addAll(
          decoded.map(
            (item) =>
                CustomerOrder.fromJson(Map<String, dynamic>.from(item as Map)),
          ),
        );
      notifyListeners();
    } catch (error) {
      debugPrint('Error loading saved orders: $error');
    }
  }

  Future<void> _saveOrders() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final encoded = jsonEncode(
        _orders.map((order) => order.toJson()).toList(),
      );
      await preferences.setString(_storageKey, encoded);
    } catch (error) {
      debugPrint('Error saving orders: $error');
    }
  }

  Future<void> addOrder(CustomerOrder order) async {
    await _ready;
    _orders.insert(0, order);
    notifyListeners();
    await _saveOrders();
  }

  CustomerOrder? findOrder(String id) {
    for (final order in _orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  Future<void> updateStatus(String orderId, String newStatus) async {
    await _ready;
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return;
    _orders[index] = _copyWithStatus(_orders[index], newStatus);
    notifyListeners();
    await _saveOrders();
  }

  Future<bool> cancelOrder(String orderId) async {
    await _ready;
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1 || !_orders[index].canCancel) return false;
    _orders[index] = _copyWithStatus(_orders[index], 'Cancelled');
    notifyListeners();
    await _saveOrders();
    return true;
  }

  CustomerOrder _copyWithStatus(CustomerOrder old, String newStatus) {
    return CustomerOrder(
      id: old.id,
      customerName: old.customerName,
      phone: old.phone,
      address: old.address,
      items: old.items,
      subtotal: old.subtotal,
      deliveryCharge: old.deliveryCharge,
      total: old.total,
      discount: old.discount,
      couponCode: old.couponCode,
      paymentMethod: old.paymentMethod,
      createdAt: old.createdAt,
      status: newStatus,
      scheduledFor: old.scheduledFor,
      scheduledTime: old.scheduledTime,
    );
  }

  Future<void> clearOrders() async {
    await _ready;
    _orders.clear();
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }
}
