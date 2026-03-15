import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/market.dart';
import '../../providers/cart_provider.dart';
import '../cart/cart_screen.dart';

class MarketDetailScreen extends ConsumerWidget {
  final Market market;
  const MarketDetailScreen({super.key, required this.market});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider.select(
      (items) => items.fold(0, (sum, item) => sum + item.quantity),
    ));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            actionsIconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            actions: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                  ),
                  if (cartCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: market.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[200]),
                errorWidget: (context, url, error) => Container(color: Colors.grey[200]),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(market.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(market.location, style: const TextStyle(color: Colors.grey)),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.schedule_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(market.hours, style: const TextStyle(color: Colors.grey)),
                  ]),
                  const SizedBox(height: 16),
                  Text(market.description, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  Text('販售商品', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _ProductCard(product: market.products[index]),
              childCount: market.products.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

}

class _ProductCard extends ConsumerWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: product.image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(width: 64, height: 64, color: Colors.grey[200]),
              errorWidget: (context, url, error) => Container(width: 64, height: 64, color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
            ),
          ),
          title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.description, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text('NT\$ ${product.price.toInt()}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          isThreeLine: true,
          trailing: FilledButton.tonal(
            onPressed: () {
              ref.read(cartProvider.notifier).add(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('已加入 ${product.name}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: const Text('加入'),
          ),
        ),
      ),
    );
  }
}
