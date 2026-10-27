// import 'dart:async';
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
//
// import '../model/session.dart';
//
//
// class SSEService {
//   final Dio _dio = Dio();
//
//   StreamSubscription? _subscription;
//
//   /// 🔥 CONNECT SSE
//   Future<void> connect({
//     required String url,
//     required Function(dynamic data) onData,
//     required Function(dynamic error) onError,
//   }) async {
//     try {
//       final token = AppSession.session?.token;
//
//       final response = await _dio.get(
//         url,
//         options: Options(
//           responseType: ResponseType.stream,
//           headers: {
//             "Accept": "text/event-stream",
//             "Cache-Control": "no-cache",
//             if (token != null) "Authorization": "Bearer $token",
//           },
//         ),
//       );
//
//       if (kDebugMode) {
//         print("✅ SSE Connected: $url");
//       }
//
//       final Stream<List<int>> stream = response.data.stream;
//
//       String buffer = "";
//
//       _subscription = stream
//           .map<String>((event) => utf8.decode(event)) // ✅ TYPE FIX
//           .transform(const LineSplitter())
//           .listen((line) {
//
//         // 🔥 ignore heartbeat/comments
//         if (line.startsWith(":")) return;
//
//         // 🔥 event separator (empty line)
//         if (line.isEmpty) {
//           if (buffer.isNotEmpty) {
//             _handleData(buffer, onData);
//             buffer = "";
//           }
//           return;
//         }
//
//         // 🔥 collect only data lines
//         if (line.startsWith("data:")) {
//           buffer += line.replaceFirst("data:", "").trim();
//         }
//       }, onError: (e) {
//         if (kDebugMode) {
//           print("❌ SSE ERROR: $e");
//         }
//         onError(e);
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print("❌ SSE CONNECT EXCEPTION: $e");
//       }
//       onError(e);
//     }
//   }
//
//   /// 🔥 HANDLE DATA
//   void _handleData(String raw, Function(dynamic data) onData) {
//     if (kDebugMode) {
//       print("📡 SSE DATA: $raw");
//     }
//
//     try {
//       final decoded = jsonDecode(raw);
//       onData(decoded);
//     } catch (_) {
//       onData(raw);
//     }
//   }
//
//   /// ❌ DISCONNECT
//   void disconnect() {
//     _subscription?.cancel();
//     _subscription = null;
//
//     if (kDebugMode) {
//       print("🔌 SSE Disconnected");
//     }
//   }
//
//   /// 🔄 AUTO RECONNECT
//   void reconnect({
//     required String url,
//     required Function(dynamic data) onData,
//     required Function(dynamic error) onError,
//     int delaySeconds = 2,
//   }) {
//     disconnect();
//
//     Future.delayed(Duration(seconds: delaySeconds), () {
//       connect(url: url, onData: onData, onError: onError);
//     });
//   }
// }