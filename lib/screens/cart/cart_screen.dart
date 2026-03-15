import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('購物車'), centerTitle: true),
      body: Consumer(
        builder: (context, ref, _) {
          final items = ref.watch(cartProvider);
          final notifier = ref.read(cartProvider.notifier);

          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('購物車是空的', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('去市集頁選購商品吧！', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: item.product.image,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(width: 72, height: 72, color: Colors.grey[200]),
                                errorWidget: (context, url, error) => Container(width: 72, height: 72, color: Colors.grey[200]),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    'NT\$ ${item.product.price.toInt()}',
                                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('確認刪除'),
                                        content: Text('確定要移除「${item.product.name}」嗎？'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx, false),
                                            child: const Text('取消'),
                                          ),
                                          FilledButton(
                                            style: FilledButton.styleFrom(backgroundColor: Colors.red),
                                            onPressed: () => Navigator.pop(ctx, true),
                                            child: const Text('刪除'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      ref.read(cartProvider.notifier).remove(item.product.id);
                                    }
                                  },
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        if (item.quantity > 1) {
                                          ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity - 1);
                                        } else {
                                          ref.read(cartProvider.notifier).remove(item.product.id);
                                        }
                                      },
                                    ),
                                    Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity + 1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 8, offset: const Offset(0, -2))],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('合計', style: TextStyle(fontSize: 16)),
                          Text(
                            'NT\$ ${notifier.totalPrice.toInt()}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('確認結帳'),
                                content: Text('共 NT\$ ${notifier.totalPrice.toInt()}，確定下單嗎？'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('取消'),
                                  ),
                                  FilledButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('確定'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true && context.mounted) {
                              ref.read(ordersProvider.notifier).addOrder(items, notifier.totalPrice);
                              notifier.clear();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('訂單已成立！')),
                              );
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text('結帳', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
