import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/mock_markets.dart';
import '../../providers/favorites_provider.dart';
import '../markets/market_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIds = ref.watch(favoritesProvider);
    final favMarkets = mockMarkets.where((m) => favIds.contains(m.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('收藏市集'), centerTitle: true),
      body: favMarkets.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('還沒有收藏的市集', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('在市集頁點擊愛心來收藏', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favMarkets.length,
              itemBuilder: (context, index) {
                final market = favMarkets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MarketDetailScreen(market: market)),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: market.image,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(width: 56, height: 56, color: Colors.grey[200]),
                        errorWidget: (context, url, error) => Container(width: 56, height: 56, color: Colors.grey[200]),
                      ),
                    ),
                    title: Text(market.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(market.hours, style: const TextStyle(fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => ref.read(favoritesProvider.notifier).toggle(market.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
