import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../ pages/now_playing_page.dart';
import '../providers/song_provider.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final playerNotifier = ref.watch(audioPlayerProvider.notifier);
    final playerState = ref.watch(playerStateProvider).value;

    if (currentSong == null) {
      return const SizedBox.shrink();
    }

    final playing = playerState?.playing ?? false;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NowPlayingPage(),
          ),
        );
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF282828),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                currentSong.albumArtUrl,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentSong.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    currentSong.artist,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 36,
                color: Colors.white,
              ),
              onPressed: () {
                if (playing) {
                  playerNotifier.pause();
                } else {
                  playerNotifier.play();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}