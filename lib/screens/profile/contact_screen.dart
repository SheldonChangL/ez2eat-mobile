import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('聯絡我們'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(radius: 36, child: Icon(Icons.eco, size: 36)),
                  const SizedBox(height: 12),
                  Text('Ez2Eat', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('北台灣小農市集平台', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ContactTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: 'ssamuelpeng60@gmail.com',
            onTap: () {
              Clipboard.setData(const ClipboardData(text: 'ssamuelpeng60@gmail.com'));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email 已複製')),
              );
            },
          ),
          _ContactTile(
            icon: Icons.code,
            title: 'GitHub',
            subtitle: 'github.com/SheldonChangL/ez2eat-web',
            onTap: () {
              Clipboard.setData(const ClipboardData(text: 'https://github.com/SheldonChangL/ez2eat-web'));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('連結已複製')),
              );
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Ez2Eat 致力於連結北台灣在地小農與消費者，讓您輕鬆找到附近的農夫市集，直接向小農購買新鮮農產品。',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text('Version 1.0.0', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.copy, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
