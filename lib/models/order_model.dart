class OrderItem {
  final String name;
  final int quantity;
  final int price;
  final int total;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'price': price,
    'total': total,
  };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as int,
      total: json['total'] as int,
    );
  }
}

class CustomerOrder {
  final String id;
  final String customerName;
  final String phone;
  final String address;
  final List<OrderItem> items;
  final int subtotal;
  final int deliveryCharge;
  final int total;
  final int discount;
  final String? couponCode;
  final String paymentMethod;
  final DateTime createdAt;
  final String status;
  final DateTime? scheduledFor;
  final String? scheduledTime;

  const CustomerOrder({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.total,
    this.discount = 0,
    this.couponCode,
    required this.paymentMethod,
    required this.createdAt,
    this.status = 'Placed',
    this.scheduledFor,
    this.scheduledTime,
  });

  bool get canCancel {
    final currentStatus = status.trim().toLowerCase();
    return currentStatus == 'placed' || currentStatus == 'confirmed';
  }

  bool get isCancelled => status.trim().toLowerCase() == 'cancelled';

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerName': customerName,
    'phone': phone,
    'address': address,
    'items': items.map((item) => item.toJson()).toList(),
    'subtotal': subtotal,
    'deliveryCharge': deliveryCharge,
    'total': total,
    'discount': discount,
    'couponCode': couponCode,
    'paymentMethod': paymentMethod,
    'createdAt': createdAt.toIso8601String(),
    'status': status,
    'scheduledFor': scheduledFor?.toIso8601String(),
    'scheduledTime': scheduledTime,
  };

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    return CustomerOrder(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (item) =>
                OrderItem.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      subtotal: json['subtotal'] as int,
      deliveryCharge: json['deliveryCharge'] as int,
      total: json['total'] as int,
      discount: json['discount'] as int? ?? 0,
      couponCode: json['couponCode'] as String?,
      paymentMethod: json['paymentMethod'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String? ?? 'Placed',
      scheduledFor: json['scheduledFor'] == null
          ? null
          : DateTime.tryParse(json['scheduledFor'] as String),
      scheduledTime: json['scheduledTime'] as String?,
    );
  }
}
