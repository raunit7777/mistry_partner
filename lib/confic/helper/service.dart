// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import '../view_model/user_view_model.dart';
//
// class UniversalSocketService {
//   // ---------------- SINGLETON ----------------
//   static final UniversalSocketService _instance = UniversalSocketService._internal();
//   factory UniversalSocketService() => _instance;
//   UniversalSocketService._internal();
//
//   // ---------------- SOCKET ----------------
//   IO.Socket? _socket;
//   bool _isConnected = false;
//
//   // ---------------- INIT ----------------
//   void universalSocketConnect() {
//     try {
//       if (_socket != null) return;
//
//       _socket = IO.io(
//         "https://payment.codescarts.com",
//         IO.OptionBuilder()
//             .setTransports(['websocket'])
//             .enableForceNew()
//             .disableAutoConnect()
//             .build(),
//       );
//
//       _setupSocketListeners();
//       _socket!.connect();
//     } catch (e) {
//       debugPrint("❌ Universal socket init error: $e");
//     }
//   }
//
//   void _setupSocketListeners() {
//     _socket!.onConnect((_) {
//       debugPrint("🟢 Universal Socket Connected");
//       _isConnected = true;
//
//       // 🔥 Driver ko join karwana (Registration)
//       _joinDriverRoom();
//
//
//       // Call and Order Listeners
//       _incomingCallListener();
//       _newOrderListener(); // Naya order notification ke liye
//     });
//
//     _socket!.onDisconnect((_) {
//       debugPrint("🔴 Universal Socket Disconnected");
//       _isConnected = false;
//       _reconnectSocket();
//     });
//
//     _socket!.onConnectError((err) {
//       debugPrint("❌ Connect error: $err");
//       _isConnected = false;
//     });
//
//     // ✅ Naya Driver Join Hone Par Confirmation
//     _socket!.on("join_driver", (driverId) {
//       debugPrint("🚗 Driver joining confirmation: $driverId");
//       debugPrint("✅ Driver joined room: driver_$driverId");
//     });
//   }
//
//   // ---------------- DRIVER REGISTRATION ----------------
//
//   Future<void> _joinDriverRoom() async {
//     final userId = await UserViewModel().getUser(); // Maan ke chal rahe hain ye Driver ID hai
//
//     if (_socket?.connected == true && userId != null) {
//       // ✅ Server ko batana ki is driver ki room join karni hai
//       _socket!.emit("join_driver", userId.toString());
//       debugPrint("📤 Emitted join_driver for ID: $userId");
//     }
//   }
//
//
// // inside UniversalSocketService
//
//   void setDriverStatus({
//     required String driverId,
//     required bool isOnline,
//     Function(dynamic)? ack,
//   }) {
//     _socket?.emitWithAck(
//       "driver_online",
//       {
//         "driver_id": driverId,
//         "status": isOnline ? "online" : "offline",
//       },
//       ack: (data) {
//         debugPrint("📡 Driver Status ACK: $data");
//         if (ack != null) ack(data);
//       },
//     );
//   }
//   // ---------------- LISTENERS ----------------
//
//   Function(dynamic)? onIncomingCall;
//   void _incomingCallListener() {
//     _socket!.on("driver_online", (data) {
//       debugPrint("📲 INCOMING CALL DATA => $data");
//       if (onIncomingCall != null) onIncomingCall!(data);
//     });
//   }
//
//   Function(dynamic)? onNewOrder;
//   void _newOrderListener() {
//     _socket!.on("new_order_assigned", (data) {
//       debugPrint("📦 NEW ORDER RECEIVED => $data");
//       if (onNewOrder != null) onNewOrder!(data);
//     });
//   }
//
//   // ---------------- EMITS (Actions) ----------------
//
//   void updateLocation({required double lat, required double lng}) async {
//     final userId = await UserViewModel().getUser();
//     if (_socket?.connected == true && userId != null) {
//       _socket!.emit("update_location", {
//         "driver_id": userId,
//         "latitude": lat,
//         "longitude": lng,
//       });
//     }
//   }
//
//   void acceptOrder(String orderId) async {
//     final userId = await UserViewModel().getUser();
//     if (_socket?.connected == true) {
//       _socket!.emit("order_accepted", {
//         "order_id": orderId,
//         "driver_id": userId,
//       });
//     }
//   }
//
//   // ---------------- RECONNECT ----------------
//   void _reconnectSocket() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (!_isConnected && _socket?.connected == false) {
//         debugPrint("🔁 Reconnecting socket...");
//         _socket?.connect();
//       }
//     });
//   }
//
//   // ---------------- GETTERS ----------------
//   bool get isConnected => _isConnected;
//   IO.Socket? get socket => _socket;
// }