import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String marketId) {
    if (state.contains(marketId)) {
      state = {...state}..remove(marketId);
    } else {
      state = {...state, marketId};
    }
  }

  bool isFavorite(String marketId) => state.contains(marketId);
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);
