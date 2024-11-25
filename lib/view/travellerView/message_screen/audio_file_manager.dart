import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';

class AudioPlayerFileManager {
  AudioPlayerFileManager(String path) {
    audioPath = path;
    debugPrint("audio path--- $audioPath");
  }
  String audioPath = "";
  final player = AudioPlayer();
  Stream<DurationState>? durationST;

  void init() {
    durationST = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
        (position, playbackEvent) => DurationState(
              progress: position,
              buffered: playbackEvent.bufferedPosition,
              total: playbackEvent.duration,
            ));
    player.setFilePath(audioPath);
  }

  void dispose() {
    player.dispose();
  }
}

class AudioPlayerManager {
  AudioPlayerManager(String url) {
    audioUrl = url;
  }
  String audioUrl = "";
  final player = AudioPlayer();
  Stream<DurationState>? durationState;

  void init() {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
        (position, playbackEvent) => DurationState(
              progress: position,
              buffered: playbackEvent.bufferedPosition,
              total: playbackEvent.duration,
            ));
    player.setUrl(audioUrl);
  }

  void dispose() {
    player.dispose();
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });
  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
