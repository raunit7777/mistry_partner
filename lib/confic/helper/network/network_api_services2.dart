import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';



import '../../../feature/model/app_session_model.dart';
import '../response/app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices2 extends BaseApiServices {

  Map<String, String> defaultHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept': 'text/event-stream',
    };

    final token = AppSession.session?.token;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      print("Bearer $token");
    }

    return headers;
  }

  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;

    final headers = defaultHeaders(); 

    try {
      final response = await http
          .get(
        Uri.parse(url),
        headers: headers,
      )
          .timeout(const Duration(seconds: 60));

      if (kDebugMode) {
        print('Api Url : $url');
        print('Api Headers : $headers');
      }

      responseJson = returnRequest(response);
    } on SocketException {
      throw FetchDataExceptions('No Internet Connection');
    }

    return responseJson;
  }


  @override
  Future getPostApiResponse(String url, dynamic data) async {
    final headers = defaultHeaders();
    dynamic responseJson;
    try {
      final response = await http
          .post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 60));
      if (kDebugMode) {
        print('Api Url : $url');
      }
      responseJson = returnRequest(response);
    } on SocketException {
      throw FetchDataExceptions('No Internet Connection');
    }
    return responseJson;
  }





  @override
  Future formPutApiResponse(
      String url,
      Map<String, dynamic> data, {
        Map<String, String>? headers,
      }) async {
    try {
      // MultipartRequest ka method 'PUT' set karein
      var request = http.MultipartRequest('PUT', Uri.parse(url));

      // Token aur Authorization headers add karein
      request.headers.addAll(defaultHeaders());
      if (headers != null) request.headers.addAll(headers);

      for (var entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value == null) continue;

        if (value is File) {
          final filename = "${DateTime.now().millisecondsSinceEpoch}.jpg";
          request.files.add(
            await http.MultipartFile.fromPath(
              key,
              value.path,
              filename: filename,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        } else {
          request.fields[key] = value.toString();
        }
      }

      var streamed = await request.send();
      var response = await http.Response.fromStream(streamed);

      return returnRequest(response);
    } catch (e) {
      throw FetchDataExceptions("Multipart PUT Failed: $e");
    }
  }


  @override
  Future getPatchApiResponse(String url, dynamic data) async {
    final headers = defaultHeaders();
    dynamic responseJson;
    try {
      final response = await http
          .patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 60));
      if (kDebugMode) {
        print('Api Url : $url');
      }
      responseJson = returnRequest(response);
    } on SocketException {
      throw FetchDataExceptions('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> getDeleteApiResponse(

      String url, {
        Map<String, String>? headers,
        dynamic body, // <--- add body
      }) async {
    dynamic responseJson;
    try {
      final headers = defaultHeaders();
      final Map<String, String> finalHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };

      // Ensure body is JSON string if provided
      final Object? encodedBody = body != null ? jsonEncode(body) : null;

      if (kDebugMode) {
        print('Api Url : $url');
        if (body != null) print('Api Body: $encodedBody');
        print('Api Headers: $finalHeaders');
      }

      final response = await http
          .delete(
        Uri.parse(url),
        headers: finalHeaders,
        body: encodedBody,
      )
          .timeout(const Duration(seconds: 60));

      responseJson = returnRequest(response);
    } on SocketException {
      throw FetchDataExceptions("No Internet Connection");
    }
    return responseJson;
  }

  // ✅ PUT
  @override
  Future<dynamic> getPutApiResponse(String url,
      dynamic data, {
        Map<String, String>? headers,
      }) async {
    final user = defaultHeaders();
    dynamic responseJson;
    try {
      final response = await http
          .put(
        Uri.parse(url),
        headers: user,
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 60));
      if (kDebugMode) {
        print('Api Url : $url');
      }
      responseJson = returnRequest(response);
    } on SocketException {
      throw FetchDataExceptions("No Internet Connection");
    }
    return responseJson;
  }


//
//   Future<dynamic> socketServiceRequest({
//     required String emitEvent,
//     required String listenEvent,
//     Map<String, dynamic>? data,
//     int timeoutSeconds = 60,
//   }) async {
//     final completer = Completer<dynamic>();
//
//     try {
//       _socket.emit(emitEvent, data);
//
//       _socket.once(listenEvent, (response) {
//         if (!completer.isCompleted) {
//           completer.complete(response);
//         }
//       });
//
//       Future.delayed(Duration(seconds: timeoutSeconds), () {
//         if (!completer.isCompleted) {
//           completer.completeError(
//             TimeoutException('Socket response timeout'),
//           );
//         }
//       });
//     } catch (e) {
//       if (!completer.isCompleted) {
//         completer.completeError(e);
//       }
//     }
//
//     return completer.future;
//   }
// }
//



  @override
  Future formPostApiResponse(
      String url,
      Map<String, dynamic> data, {
        Map<String, String>? headers,
      }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Remove wrong Content-Type if coming
      headers?.remove('Content-Type');
      if (headers != null) request.headers.addAll(headers);

      for (var entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value == null) continue;

        if (value is File) {
          final filename =
              "${DateTime.now().millisecondsSinceEpoch}.jpg"; // 🔥 force valid extension

          request.files.add(
            await http.MultipartFile.fromPath(
              key,
              value.path,
              filename: filename, // IMPORTANT
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        } else {
          request.fields[key] = value.toString();
        }
      }

      var streamed = await request.send();
      var response = await http.Response.fromStream(streamed);

      return returnRequest(response);
    } catch (e) {
      throw FetchDataExceptions("Multipart Upload Failed: $e");
    }
  }


    // @override
    // Future formPostApiResponse(String url, Map<String, dynamic> data) async {
    //   try {
    //     var request = http.MultipartRequest('POST', Uri.parse(url));
    //
    //     data.forEach((key, value) async {
    //       if (value is! File) {
    //         request.fields[key] = value.toString();
    //       }
    //     });
    //
    //     for (var entry in data.entries) {
    //       if (entry.value is File) {
    //         request.files.add(
    //           await http.MultipartFile.fromPath(
    //               entry.key, (entry.value as File).path),
    //         );
    //       }
    //     }
    //
    //     var streamedResponse = await request.send();
    //     var response = await http.Response.fromStream(streamedResponse);
    //
    //     if (kDebugMode) {
    //       print('📤 URL: $url');
    //       print('📦 Status: ${response.statusCode}');
    //       print('🧾 Response: ${response.body}');
    //     }
    //
    //     return returnRequest(response);
    //   } on SocketException {
    //     throw FetchDataExceptions('No Internet Connection');
    //   } catch (e) {
    //     if (kDebugMode) print('❌ Multipart Error: $e');
    //     rethrow;
    //   }
    // }

    // Updated returnRequest method - ab response code ke sath data return karega
    dynamic returnRequest(http.Response response) {
      dynamic responseJson;

      // Response body ko decode karne ki koshish karein
      try {
        responseJson = jsonDecode(response.body);
      } catch (e) {
        responseJson = response.body;
      }

      if (kDebugMode) {
        print('Response Code: ${response.statusCode}');
        print('Response Body: $responseJson');
      }


      switch (response.statusCode) {
        case 200:
        case 201:
          return {
            'statusCode': response.statusCode,
            'data': responseJson,
            'msg': responseJson['message']
          };
        case 400:
          return {
            'statusCode': response.statusCode,
            'data': responseJson,
            'msg': responseJson['message']
          };
        case 401:
          return {
            'statusCode': response.statusCode,
            'data': responseJson,
            'msg': responseJson['message']
            // 'success': false,
            // 'error': 'Unauthorized',
          };
        case 404:
          return {
            'statusCode': response.statusCode,
            'data': responseJson,
            'msg': responseJson['message']
          };
        case (>= 500):
          return {
            'statusCode': response.statusCode,
            'data': responseJson,
            'msg': responseJson['message']
          };
        default:
          return {
            'statusCode': response.statusCode,
            'data': responseJson,
            'success': false,
            'error': 'Unknown Error',
          };
      }
    }
  }
