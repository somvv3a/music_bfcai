import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/song_provider.dart';

class PlaylistsPage extends ConsumerWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistsProvider);

    if (playlists.isEmpty) {
      return const Center(
        child: Text('No songs in your playlist yet.', style: TextStyle(color: Colors.white70)),
      );
    }

    return ListView.builder(
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final song = playlists[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                song.albumArtUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(song.title, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(song.artist, style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              // Future feature: play song from playlist
            },
          ),
        );
      },
    );
  }
}