import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_app/%20widgets/seekbar.dart';
import 'package:just_audio/just_audio.dart';


import '../providers/song_provider.dart';

class PlayerControls extends ConsumerWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final playerNotifier = ref.watch(audioPlayerProvider.notifier);
    final playerState = ref.watch(playerStateProvider);
    final isShuffling = ref.watch(shuffleModeProvider);
    final repeatMode = ref.watch(repeatModeProvider);
    final hasNext = ref.watch(audioPlayerProvider).hasNext;
    final hasPrevious = ref.watch(audioPlayerProvider).hasPrevious;
    final positionData = ref.watch(positionDataStreamProvider).value;

    if (currentSong == null) {
      return const Center(child: Text("No song selected.", style: TextStyle(color: Colors.white70)));
    }

    final processingState = playerState.when(
      data: (state) => state.processingState,
      loading: () => ProcessingState.loading,
      error: (e, stack) => ProcessingState.ready,
    );

    final playing = playerState.when(
      data: (state) => state.playing,
      loading: () => false,
      error: (e, stack) => false,
    );

    return Column(
      children: [
        Text(
          currentSong.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          currentSong.artist,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        if (positionData != null)
          SeekBar(
            duration: positionData.duration,
            position: positionData.position,
            bufferedPosition: positionData.bufferedPosition,
            onChanged: (newPosition) {
              playerNotifier.seek(newPosition);
            },
          )
        else
          const LinearProgressIndicator(
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                isShuffling ? Icons.shuffle_on_rounded : Icons.shuffle_rounded,
                color: isShuffling ? Colors.blueAccent : Colors.white70,
                size: 28,
              ),
              onPressed: playerNotifier.toggleShuffle,
            ),
            IconButton(
              icon: Icon(
                Icons.skip_previous_rounded,
                size: 48,
                color: hasPrevious ? Colors.white : Colors.white38,
              ),
              onPressed: hasPrevious ? playerNotifier.previous : null,
            ),
            IconButton(
              icon: Icon(
                playing ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                size: 72,
                color: Colors.blueAccent,
              ),
              onPressed: processingState == ProcessingState.ready
                  ? () {
                if (playing) {
                  playerNotifier.pause();
                } else {
                  playerNotifier.play();
                }
              }
                  : null,
            ),
            IconButton(
              icon: Icon(
                Icons.skip_next_rounded,
                size: 48,
                color: hasNext ? Colors.white : Colors.white38,
              ),
              onPressed: hasNext ? playerNotifier.next : null,
            ),
            IconButton(
              icon: Icon(
                repeatMode == RepeatMode.one
                    ? Icons.repeat_one_rounded
                    : Icons.repeat_rounded,
                color: repeatMode != RepeatMode.off ? Colors.blueAccent : Colors.white70,
                size: 28,
              ),
              onPressed: playerNotifier.toggleRepeat,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.volume_down_rounded, color: Colors.white70),
            Expanded(
              child: Slider(
                min: 0.0,
                max: 1.0,
                value: ref.watch(audioPlayerProvider).volume,
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.white12,
                onChanged: (volume) {
                  playerNotifier.setVolume(volume);
                },
              ),
            ),
            const Icon(Icons.volume_up_rounded, color: Colors.white70),
          ],
        ),
      ],
    );
  }
}