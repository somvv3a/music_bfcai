import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_app/%20pages/playlists_page.dart';
import '../ widgets/mini_player.dart';
import '../providers/song_provider.dart';
import 'favorites_page.dart';
import 'home_page.dart';

// A StateProvider to manage the current index of the bottom navigation bar.
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);
    final currentSong = ref.watch(currentSongProvider);
    final pages = [
      const HomePage(),
      const PlaylistsPage(),
      const FavoritesPage(),
    ];
    final titles = ['Home', 'Playlists', 'Favorites'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Make app bar transparent
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music),
            label: 'Playlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
      ),
      bottomSheet: currentSong != null ? const MiniPlayer() : null,
    );
  }
}
