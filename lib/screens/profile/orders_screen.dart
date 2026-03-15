import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/orders_provider.dart';
import '../../models/order.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('訂單紀錄'), centerTitle: true),
      body: orders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('還沒有訂單', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) => _OrderCard(order: orders[index]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text('訂單 #${order.id.substring(order.id.length - 6)}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${order.createdAt.year}/${order.createdAt.month.toString().padLeft(2, '0')}/${order.createdAt.day.toString().padLeft(2, '0')}  NT\$ ${order.total.toInt()}',
          style: const TextStyle(fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Text(order.status, style: const TextStyle(color: Colors.green, fontSize: 12)),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          const Divider(height: 1),
          ...order.items.map((item) => ListTile(
                dense: true,
                title: Text(item.product.name),
                trailing: Text('NT\$ ${item.product.price.toInt()} × ${item.quantity}'),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('合計', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('NT\$ ${order.total.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
