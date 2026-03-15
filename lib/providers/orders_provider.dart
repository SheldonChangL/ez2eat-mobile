import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrdersNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() => [];

  void addOrder(List<CartItem> items, double total) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(items),
      total: total,
      createdAt: DateTime.now(),
    );
    state = [order, ...state];
  }
}

final ordersProvider = NotifierProvider<OrdersNotifier, List<Order>>(OrdersNotifier.new);
