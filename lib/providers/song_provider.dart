import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';

import '../models/song.dart';

// Enum for repeat modes
enum RepeatMode { off, all, one }

// A provider for the list of all songs, organized by category.
final songsByCategoryProvider = Provider<Map<String, List<Song>>>((ref) {
  return {
    'Hip Hop': [
      Song(
        title: 'Lost Your Faith',
        artist: 'Ava Max',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        category: 'Hip Hop',
      ),
      Song(
        title: 'Leon',
        artist: 'leon Bridges',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        category: 'Hip Hop',
      ),
    ],
    'Hindi': [
      Song(
        title: 'Sahiba',
        artist: 'Aditya Rikhari',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        category: 'Hindi',
      ),
      Song(
        title: 'Raanjhan',
        artist: 'Sachet-Parampara',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
        category: 'Hindi',
      ),
      Song(
        title: 'Mann Mera',
        artist: 'Gajendra Verma',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
        category: 'Hindi',
      ),
    ],
    'Telugu': [
      Song(
        title: 'Firestrom',
        artist: 'Thaman',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
        category: 'Telugu',
      ),
      Song(
        title: 'Pushpa',
        artist: 'Devi',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
        category: 'Telugu',
      ),
    ],
    'Melody': [
      Song(
        title: 'Die for you',
        artist: 'Weekend',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
        category: 'Melody',
      ),
      Song(
        title: 'Remainder',
        artist: 'Weekend',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
        category: 'Melody',
      ),
      Song(
        title: 'Blinding lights',
        artist: 'Weekend',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
        category: 'Melody',
      ),
    ],
    'Pop': [
      Song(
        title: 'Star boy',
        artist: 'Weekend',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3',
        category: 'Pop',
      ),
      Song(
        title: 'lucky',
        artist: 'Halsey',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3',
        category: 'Pop',
      ),
    ],
    'Rock': [
      Song(
        title: 'Super six',
        artist: 'Weekend',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3',
        category: 'Rock',
      ),
    ],
    'Jazz': [
      Song(
        title: 'Remainder',
        artist: 'WE',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3',
        category: 'Jazz',
      ),
    ],
    'Classical': [
      Song(
        title: 'Die For You',
        artist: 'WE',
        albumArtUrl: 'https://placehold.co/100x100/png',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3',
        category: 'Classical',
      ),
    ],
  };
});

// A provider for the list of categories.
final categoriesProvider = Provider<List<String>>((ref) {
  return ref.watch(songsByCategoryProvider).keys.toList();
});

// A provider for the currently selected category.
final selectedCategoryProvider = StateProvider<String>((ref) {
  return ref.watch(categoriesProvider).first;
});

// A provider for the list of songs in the currently selected category.
final songsInSelectedCategoryProvider = Provider<List<Song>>((ref) {
  final songsByCategory = ref.watch(songsByCategoryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  return songsByCategory[selectedCategory] ?? [];
});

// A StateProvider for the index of the currently playing song in the list.
final currentSongIndexProvider = StateProvider<int?>((ref) => null);

// A provider for the currently playing song object.
final currentSongProvider = Provider<Song?>((ref) {
  final songs = ref.watch(songsInSelectedCategoryProvider);
  final index = ref.watch(currentSongIndexProvider);
  if (index != null && index >= 0 && index < songs.length) {
    return songs[index];
  }
  return null;
});

// A provider for the current player state (playing, paused, etc.).
final playerStateProvider = StreamProvider.autoDispose<PlayerState>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.playerStateStream;
});

// A StateProvider for the repeat mode
final repeatModeProvider = StateProvider<RepeatMode>((ref) => RepeatMode.off);

// A StateProvider for the shuffle mode
final shuffleModeProvider = StateProvider<bool>((ref) => false);

// The AudioPlayer provider, now managed by a StateNotifier.
final audioPlayerProvider = StateNotifierProvider<MusicPlayerNotifier, AudioPlayer>((ref) {
  return MusicPlayerNotifier(ref);
});

// A new provider for the combined position data stream
final positionDataStreamProvider = StreamProvider.autoDispose<PositionData>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.positionDataStream;
});

// New providers for favorites and playlists
final favoritesProvider = StateProvider<List<Song>>((ref) => []);
final playlistsProvider = StateProvider<List<Song>>((ref) => []);

// StateNotifier to manage all the music player logic
class MusicPlayerNotifier extends StateNotifier<AudioPlayer> {
  final Ref _ref;

  MusicPlayerNotifier(this._ref) : super(AudioPlayer()) {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Listen for completion to automatically play the next song
    state.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      if (state.processingState == ProcessingState.completed) {
        if (_ref.read(repeatModeProvider) == RepeatMode.one) {
          _ref.read(currentSongIndexProvider.notifier).state = state.currentIndex;
          state.seek(Duration.zero);
        } else if (_ref.read(repeatModeProvider) == RepeatMode.all) {
          _ref.read(currentSongIndexProvider.notifier).state = (state.currentIndex! + 1) % state.sequence!.length;
        } else {
          // No repeat, just go to the next song if it exists
          if (state.hasNext) {
            _ref.read(currentSongIndexProvider.notifier).state = state.currentIndex! + 1;
          } else {
            // Reached the end of the playlist
            _ref.read(currentSongIndexProvider.notifier).state = null;
            state.stop();
          }
        }
      }
    });
  }

  Future<void> playSong(int index) async {
    final songs = _ref.read(songsInSelectedCategoryProvider);
    _ref.read(currentSongIndexProvider.notifier).state = index;

    final playlist = ConcatenatingAudioSource(
      children: songs.map((song) => AudioSource.uri(Uri.parse(song.audioUrl))).toList(),
    );

    try {
      await state.setAudioSource(playlist, initialIndex: index);
      state.play();
    } catch (e) {
      // Handle potential errors
      print("Error playing song: $e");
    }
  }

  void play() {
    state.play();
  }

  void pause() {
    state.pause();
  }

  void seek(Duration position) {
    state.seek(position);
  }

  void next() {
    if (state.hasNext) {
      state.seekToNext();
      _ref.read(currentSongIndexProvider.notifier).state = state.currentIndex;
    }
  }

  void previous() {
    if (state.hasPrevious) {
      state.seekToPrevious();
      _ref.read(currentSongIndexProvider.notifier).state = state.currentIndex;
    }
  }

  void setVolume(double volume) {
    state.setVolume(volume);
  }

  void toggleShuffle() {
    final isShuffling = _ref.read(shuffleModeProvider);
    _ref.read(shuffleModeProvider.notifier).state = !isShuffling;
    state.setShuffleModeEnabled(!isShuffling);
  }

  void toggleRepeat() {
    final currentMode = _ref.read(repeatModeProvider);
    if (currentMode == RepeatMode.off) {
      _ref.read(repeatModeProvider.notifier).state = RepeatMode.all;
      state.setLoopMode(LoopMode.all);
    } else if (currentMode == RepeatMode.all) {
      _ref.read(repeatModeProvider.notifier).state = RepeatMode.one;
      state.setLoopMode(LoopMode.one);
    } else {
      _ref.read(repeatModeProvider.notifier).state = RepeatMode.off;
      state.setLoopMode(LoopMode.off);
    }
  }

  void addToFavorites(Song song) {
    final favorites = _ref.read(favoritesProvider.notifier);
    if (!favorites.state.any((s) => s.title == song.title)) {
      favorites.state = [...favorites.state, song];
    }
  }

  void addToPlaylist(Song song) {
    final playlists = _ref.read(playlistsProvider.notifier);
    if (!playlists.state.any((s) => s.title == song.title)) {
      playlists.state = [...playlists.state, song];
    }
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}

// A new data class to hold the position data for the seekbar.
class PositionData {
  const PositionData(
      this.position,
      this.bufferedPosition,
      this.duration,
      );
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

// Extension on AudioPlayer to combine position streams
extension on AudioPlayer {
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          positionStream,
          bufferedPositionStream,
          durationStream,
              (position, bufferedPosition, duration) => PositionData(
            position,
            bufferedPosition,
            duration ?? Duration.zero,
          ));
}