import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/mock_markets.dart';
import '../../models/market.dart';
import 'market_detail_screen.dart';

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('市集'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockMarkets.length,
        itemBuilder: (context, index) {
          return _MarketCard(market: mockMarkets[index]);
        },
      ),
    );
  }
}

class _MarketCard extends StatelessWidget {
  final Market market;
  const _MarketCard({required this.market});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MarketDetailScreen(market: market)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: market.image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(height: 180, color: Colors.grey[200], child: const Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => Container(height: 180, color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 48)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(market.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(child: Text(market.location, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey))),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.schedule_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(market.hours, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
