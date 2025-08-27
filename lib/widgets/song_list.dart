import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ pages/now_playing_page.dart';
import '../models/song.dart';
import '../providers/song_provider.dart';

class SongList extends ConsumerWidget {
  const SongList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsInSelectedCategoryProvider);

    return ListView.builder(
      itemCount: songs.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final song = songs[index];
        return SongListItem(song: song, index: index);
      },
    );
  }
}

class SongListItem extends ConsumerWidget {
  const SongListItem({super.key, required this.song, required this.index});

  final Song song;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final isSelected = currentSong?.title == song.title;

    return Card(
      elevation: isSelected ? 8 : 2,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: isSelected
            ? BorderSide(color: Colors.blueAccent.withOpacity(0.6), width: 1.5)
            : BorderSide.none,
      ),
      color: isSelected ? const Color(0xFF282828) : const Color(0xFF1E1E1E),
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
        title: Text(
          song.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isSelected ? Colors.blueAccent : Colors.white,
          ),
        ),
        subtitle: Text(
          song.artist,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.play_circle_fill, color: Colors.blueAccent)
            : null,
        onTap: () async {
          ref.read(audioPlayerProvider.notifier).playSong(index);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NowPlayingPage(),
            ),
          );
        },
      ),
    );
  }
}