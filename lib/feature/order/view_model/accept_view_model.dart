import 'package:flutter/foundation.dart';
import '../../shocket/universal_shocket.dart';

class OrderAcceptViewModel with ChangeNotifier {
  bool _isAccepting = false;
  bool get isAccepting => _isAccepting;


  Future<void> acceptOrder(dynamic bookingId) async {
    _isAccepting = true;
    notifyListeners();

    try {
      // Socket emit call
      UniversalSocketService().emitAcceptBooking(bookingId);



    } catch (e) {
      debugPrint("❌ Error accepting order: $e");
    } finally {

      _isAccepting = false;
      notifyListeners();
    }
  }
}