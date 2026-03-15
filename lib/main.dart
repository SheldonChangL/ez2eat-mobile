import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/map/map_screen.dart';
import 'screens/markets/markets_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() {
  runApp(const ProviderScope(child: Ez2EatApp()));
}

final _router = GoRouter(
  initialLocation: '/map',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/map', builder: (context, state) => const MapScreen()),
        GoRoute(path: '/markets', builder: (context, state) => const MarketsScreen()),
        GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      ],
    ),
  ],
);

class Ez2EatApp extends StatelessWidget {
  const Ez2EatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ez2Eat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/markets')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/map');
            case 1:
              context.go('/markets');
            case 2:
              context.go('/profile');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: '地圖',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: '市集',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
