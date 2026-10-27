import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../res/aap_urls.dart';
import '../booking/view_model/booking_view_model.dart';
import '../model/app_session_model.dart';

class UniversalSocketService {
  // Singleton pattern
  static final UniversalSocketService _instance = UniversalSocketService._internal();
  factory UniversalSocketService() => _instance;
  UniversalSocketService._internal();

  IO.Socket? _socket;
  BookingViewModel2? _vm;


  void connect(BookingViewModel2 viewModel) {
    _vm = viewModel;

    final token = AppSession.session?.token;
    _socket = IO.io(AppUrl.baseUrl, IO.OptionBuilder()
        .setTransports(['websocket'])
        .setAuth({'token': token})
        .enableReconnection()
        .build());

    _setupListeners();
    _socket!.connect();
  }

  void _setupListeners() {
    _socket!.onConnect((_) => debugPrint("🟢 Socket Connected: ${_socket!.id}"));
    _socket!.onDisconnect((_) => debugPrint("🔴 Socket Disconnected"));
    _socket!.onConnectError((err) => debugPrint("❌ Connection Error: $err"));

    // LISTENERS (ON)
    _socket!.on("new_booking_alert", (data) {
      debugPrint("🔔 New Booking Alert Received: $data");

      if (data != null && _vm != null) {

        _vm!.setNewBooking(data);

        // 2. Server ko Ack bhejo
        final bookingId = data['booking_id'];
        if (bookingId != null) {
          debugPrint("📡 Sending Acknowledgement for booking: $bookingId");
          _socket?.emit('booking_received_ack', {'booking_id': bookingId});
        }
      }
    });

    _socket!.on("booking_response", (data) => debugPrint("📋 Booking Response: $data"));
    _socket!.on("availability_updated", (data) => debugPrint("🟢 Availability Updated: $data"));
    _socket!.on("booking_accepted", (data) => debugPrint("✅ Booking Accepted: $data"));
    _socket!.on("booking_updated", (data) => debugPrint("📝 Booking Updated: $data"));
    _socket!.on("payment_confirmed", (data) => debugPrint("💰 Payment Confirmed: $data"));
    _socket!.on("receive_message", (data) => debugPrint("💬 Message: $data"));
  }

  // ---------------- EMITS ----------------

  void emitWorkerAvailability(String status, double lat, double lng) {
    _socket?.emit('worker_availability', {'status': status, 'latitude': lat, 'longitude': lng});
  }

  void emitWorkerLocation(double lat, double lng) {
    _socket?.emit('worker_location', {'latitude': lat, 'longitude': lng});
  }

  void emitAcceptBooking(dynamic bookingId) {
    debugPrint("✅ Emitting Accept Booking: $bookingId");
    _socket?.emit('accept_booking', {'booking_id': bookingId});
  }

  void emitRejectBooking(int bookingId) {
    debugPrint("❌ Emitting Reject Booking: $bookingId");
    _socket?.emit('reject_booking', {'booking_id': bookingId});
  }

  void disconnect() {
    _socket?.disconnect();
  }
}