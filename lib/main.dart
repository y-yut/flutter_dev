import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'items/items_provider.dart';
import 'favorites/favorites_provider.dart';

void main() {
  // runApp(const MyApp());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('あなたの趣味は？'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final item = items[index];
          final isFavorite = favorites.valueOrNull?.contains(item) ?? false;

          return ListTile(
            leading: IconButton(
              onPressed: (){
                if (isFavorite) {
                  ref.read(favoritesProvider.notifier).removeItem(item);
                } else {
                  ref.read(favoritesProvider.notifier).addItem(item);
                }
              },
              icon: isFavorite
                ? const Icon(
                  Icons.favorite,
                  color: Colors.pink,
                )
                : const Icon(
                  Icons.favorite_outline,
                )
            ),
            title: Text(item),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailPage(item: item),
                ),
              );
            },
          );
        },
        itemCount: items.length,
      ),
    );
  }
}

class ItemDetailPage extends ConsumerWidget {
  const ItemDetailPage({required this.item, super.key});

  final String item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

  final favorites = ref.watch(favoritesProvider);
  final isFavorite = favorites.valueOrNull?.contains(item) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('${item}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${item}の詳細画面',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            IconButton(
              onPressed: (){
                if (isFavorite) {
                  ref.read(favoritesProvider.notifier).removeItem(item);
                } else {
                  ref.read(favoritesProvider.notifier).addItem(item);
                }
              },
              icon: isFavorite
                ? const Icon(
                    Icons.favorite,
                    size: 50,
                    color: Colors.pink,
                  )
                : const Icon(
                    Icons.favorite_outline,
                    size: 50,
                  )
            )
          ],
        ),
      ),
    );
  }
}