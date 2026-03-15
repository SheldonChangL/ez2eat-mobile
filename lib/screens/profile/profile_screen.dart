import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/auth_provider.dart';
import '../../providers/orders_provider.dart';
import 'payment_screen.dart';
import 'contact_screen.dart';
import 'orders_screen.dart';
import 'favorites_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('我的'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 登入區塊
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (user != null && user.photoUrl != null)
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: CachedNetworkImageProvider(user.photoUrl!),
                    )
                  else
                    const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
                  const SizedBox(height: 12),
                  Text(
                    user != null ? (user.displayName ?? user.email) : '尚未登入',
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (user != null) ...[
                    const SizedBox(height: 4),
                    Text(user.email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => ref.read(authProvider.notifier).signOut(),
                      icon: const Icon(Icons.logout),
                      label: const Text('登出'),
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final error = await ref.read(authProvider.notifier).signIn();
                        if (error != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        }
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('使用 Google 登入'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: const Text('收藏市集'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  ),
                ),
                const Divider(height: 1),
                Consumer(builder: (context, ref, _) {
                  final count = ref.watch(ordersProvider).length;
                  return ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: const Text('訂單紀錄'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (count > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('$count', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12)),
                          ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrdersScreen()),
                    ),
                  );
                }),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('付款資訊'),
                  subtitle: const Text('信用卡 / LINE Pay'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaymentScreen()),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.mail_outline),
                  title: const Text('聯絡我們'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactScreen()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
