// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../outer/view/order_details.dart';
// import '../model/order_model.dart';
// import '../repo/order_repo.dart';
//
// class ViewModelOrder with ChangeNotifier {
//   final OrderRepository _goalRepo = OrderRepository();
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   OrderModel? _serviceListData;
//   OrderModel? get serviceListData => _serviceListData;
//
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   Future<void> serviceApi(BuildContext context) async {
//
//     print("🚩 [1] serviceApi called");
//     _setLoading(true);
//
//     try {
//       final response = await _goalRepo.orderApi();
//       print("🚩 [2] API Response received: $response");
//
//       if (response != null) {
//         // Aapke AddonViewModel ke pattern par statusCode extract kiya
//         final int statusCode = response["statusCode"] ?? 0;
//         print("🚩 [3] Extracted Status Code: $statusCode");
//
//         if (statusCode == 200) {
//           print("🚩 [4] Success! Status 200. Parsing data into model.");
//
//           Map<String, dynamic> jsonBody;
//           // Body ya data field check karne ke liye safety check
//           if (response.containsKey('data') || response.containsKey('body')) {
//             jsonBody = (response['data'] ?? response['body']) as Map<String, dynamic>;
//           } else {
//             jsonBody = response as Map<String, dynamic>;
//           }
//
//           _serviceListData = OrderModel.fromJson(jsonBody);
//           Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsScreen(booking: booking)));
//
//     } else {
//           print("🚩 [5] Failure! Status $statusCode. Data not saved.");
//           // Agar aap chaho toh yahan toast ya alert dikha sakte ho
//         }
//       } else {
//         print("🚩 [3] Null response received from repository");
//       }
//     } catch (e, stack) {
//       print("🚩 [ERROR] Catch block triggered in serviceApi: $e");
//       if (kDebugMode) {
//         print(stack);
//       }
//     } finally {
//       print("🚩 [6] Finally block. Loading state set to false.");
//       _setLoading(false);
//     }
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../outer/view/order_details.dart';
import '../model/order_model.dart';
import '../repo/order_repo.dart';

class ViewModelOrder with ChangeNotifier {
  final OrderRepository _goalRepo = OrderRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OrderModel? _serviceListData;
  OrderModel? get serviceListData => _serviceListData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> serviceApi(BuildContext context) async {
    print("🚩 [1] serviceApi called");
    _setLoading(true);

    try {
      final response = await _goalRepo.orderApi();
      print("🚩 [2] API Response received: $response");

      if (response != null) {
        final int statusCode = response["statusCode"] ?? 0;
        print("🚩 [3] Extracted Status Code: $statusCode");

        if (statusCode == 200) {
          print("🚩 [4] Success! Status 200. Parsing data into model.");

          Map<String, dynamic> jsonBody;
          if (response.containsKey('data') || response.containsKey('body')) {
            jsonBody = (response['data'] ?? response['body']) as Map<String, dynamic>;
          } else {
            jsonBody = response as Map<String, dynamic>;
          }

          _serviceListData = OrderModel.fromJson(jsonBody);
          print("🚩 [5] Data successfully saved to _serviceListData");

          // ✅ Context safety check lagaya taaki async gap me crash na ho
          if (context.mounted) {
            // Aapke model ke structure ke mutabik ongoing data ko pass kiya
            final ongoingBooking = _serviceListData?.data?.ongoing;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailsScreen(booking: ongoingBooking),
              ),
            );
            print("🚩 [6] Navigated to OrderDetailsScreen with booking data.");
          }

        } else {
          print("🚩 [5] Failure! Status $statusCode. Data not saved.");
        }
      } else {
        print("🚩 [3] Null response received from repository");
      }
    } catch (e, stack) {
      print("🚩 [ERROR] Catch block triggered in serviceApi: $e");
      if (kDebugMode) {
        print(stack);
      }
    } finally {
      print("🚩 [7] Finally block. Loading state set to false.");
      _setLoading(false);
    }
  }
}