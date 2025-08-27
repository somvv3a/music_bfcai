import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ widgets/player_controls.dart';
import '../providers/song_provider.dart';

class NowPlayingPage extends ConsumerWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((song) => song.title == currentSong?.title);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : Colors.white70,
            ),
            onPressed: () {
              if (currentSong != null) {
                ref.read(audioPlayerProvider.notifier).addToFavorites(currentSong);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? '${currentSong.title} removed from Favorites'
                          : '${currentSong.title} added to Favorites',
                    ),
                  ),
                );
              }
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.playlist_add),
            color: const Color(0xFF1E1E1E),
            onSelected: (value) {
              if (currentSong != null) {
                ref.read(audioPlayerProvider.notifier).addToPlaylist(currentSong);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${currentSong.title} added to Playlist'),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Default Playlist'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice, style: const TextStyle(color: Colors.white)),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900.withOpacity(0.8),
              const Color(0xFF121212),
            ],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: AnimatedAlbumArt(),
                ),
              ),
              PlayerControls(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

// A new widget for the animated album art
class AnimatedAlbumArt extends ConsumerWidget {
  const AnimatedAlbumArt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final isPlaying = ref.watch(playerStateProvider).value?.playing ?? false;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isPlaying ? 300 : 250,
      width: isPlaying ? 300 : 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: currentSong != null
            ? Image.network(
          currentSong.albumArtUrl,
          fit: BoxFit.cover,
        )
            : Container(
          color: Colors.grey.shade800,
          child: const Icon(Icons.music_note, size: 100, color: Colors.white54),
        ),
      ),
    );
  }
}