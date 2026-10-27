// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
//
// class SoundHelper2 {
//   static AudioPlayer? _player;
//
//   // Singleton Player Instance
//   static AudioPlayer get player {
//     _player ??= AudioPlayer();
//     return _player!;
//   }
//
//   /// 🔥 Play ringtone with LOOP (audioplayers version)
//   static Future<void> playClick() async {
//     debugPrint('🔊 SoundHelper2.playClick() (audioplayers) called');
//     try {
//       final p = player;
//
//       // 1. Purana stop karein
//       await stop();
//
//       // 2. Loop mode set karein (Ringtone ke liye zaroori)
//       await p.setReleaseMode(ReleaseMode.loop);
//
//       // 3. Volume set karein
//       await p.setVolume(1.0);
//
//       // 4. Play from assets
//       // Note: audioplayers mein path 'audio/filename.mp3' hota hai (agar assets/audio mein hai)
//       // Lekin safest tarika AssetSource use karna hai
//       await p.play(
//         AssetSource('audio/freesound_community-rotary-phone-ring-long-84542.mp3'),
//       );
//
//       debugPrint('✅ Playing ringtone in loop');
//     } catch (e, st) {
//       debugPrint('❌ Sound play error: $e');
//       if (kDebugMode) {
//         print("Stack trace: $st");
//       }
//     }
//   }
//
//   /// 🛑 STOP ringtone / any playing audio
//   static Future<void> stop() async {
//     debugPrint('🛑 SoundHelper2.stop() called');
//     try {
//       if (_player != null) {
//         await _player!.stop();
//         debugPrint('✅ Audio stopped successfully');
//       }
//     } catch (e) {
//       debugPrint('❌ Sound stop error: $e');
//     }
//   }
//
//   /// ⏳ Preload (Reduce latency)
//   static Future<void> preload() async {
//     debugPrint('⏳ SoundHelper2.preload() called');
//     try {
//       final p = player;
//       // Pre-set the source
//       await p.setSource(AssetSource('audio/freesound_community-rotary-phone-ring-long-84542.mp3'));
//       debugPrint('🎧 Preload successful');
//     } catch (e) {
//       debugPrint('❌ Sound preload failed: $e');
//     }
//   }
//
//   /// ⏸️ Pause audio
//   static Future<void> pause() async {
//     try {
//       if (_player != null) {
//         await _player!.pause();
//         debugPrint('✅ Audio paused');
//       }
//     } catch (e) {
//       debugPrint('❌ Pause error: $e');
//     }
//   }
//
//   /// ▶️ Resume audio
//   static Future<void> resume() async {
//     try {
//       if (_player != null) {
//         await _player!.resume();
//         debugPrint('✅ Audio resumed');
//       }
//     } catch (e) {
//       debugPrint('❌ Resume error: $e');
//     }
//   }
//
//   /// 🗑️ Dispose
//   static Future<void> dispose() async {
//     try {
//       if (_player != null) {
//         await _player!.dispose();
//         _player = null;
//         debugPrint('♻️ Player disposed');
//       }
//     } catch (e) {
//       debugPrint('❌ Dispose error: $e');
//     }
//   }
// }