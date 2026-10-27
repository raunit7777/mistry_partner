// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
//
//
// import '../../../model/app_session_model.dart';
// import '../response/app_exceptions.dart';
// import 'base_api_services.dart';
//
// class NetworkApiService extends BaseApiServices {
//
//
//
//   final defaultHeaders = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     if (AppSession.session?.token != null)
//       'Authorization': 'Bearer ${AppSession.session!.token}',
//
//   };
//
//
//
//
//   @override
//   Future<dynamic> getGetApiResponse(String url,
//       {Map<String, String>? headers}) async
//   {
//     try {
//       final response = await http
//           .get(Uri.parse(url), headers: headers ?? defaultHeaders)
//           .timeout(const Duration(seconds: 60));
//       return returnResponse(response);
//     } on SocketException {
//       throw FetchDataExceptions("No Internet Connection");
//     }
//   }
//
//   // ✅ POST
//   @override
//   Future<dynamic> getPostApiResponse(String url, dynamic data,
//       {Map<String, String>? headers}) async {
//     try {
//       final response = await http
//           .post(Uri.parse(url),
//           headers: headers ?? defaultHeaders, body: jsonEncode(data))
//           .timeout(const Duration(seconds: 60));
//       return returnResponse(response);
//     } on SocketException {
//       throw FetchDataExceptions("No Internet Connection");
//     }
//   }
//
//   // ✅ PUT
//   @override
//   Future<dynamic> getPutApiResponse(String url, dynamic data,
//       {Map<String, String>? headers}) async {
//     try {
//       final response = await http
//           .put(Uri.parse(url),
//           headers: headers ?? defaultHeaders, body: jsonEncode(data))
//           .timeout(const Duration(seconds: 60));
//       return returnResponse(response);
//     } on SocketException {
//       throw FetchDataExceptions("No Internet Connection");
//     }
//   }
//
//   // ✅ PATCH
//   @override
//   Future<dynamic> getPatchApiResponse(String url, dynamic data,
//       {Map<String, String>? headers}) async {
//     try {
//       final response = await http
//           .patch(Uri.parse(url),
//           headers: headers ?? defaultHeaders, body: jsonEncode(data))
//           .timeout(const Duration(seconds: 60));
//       return returnResponse(response);
//     } on SocketException {
//       throw FetchDataExceptions("No Internet Connection");
//     }
//   }
//
//   // ✅ DELETE
//   @override
//   Future<dynamic> getDeleteApiResponse(String url,
//       {Map<String, String>? headers}) async {
//     try {
//       final response = await http
//           .delete(Uri.parse(url), headers: headers ?? defaultHeaders)
//           .timeout(const Duration(seconds: 60));
//       return returnResponse(response);
//     } on SocketException {
//       throw FetchDataExceptions("No Internet Connection");
//     }
//   }
//
//   // ✅ HEAD
//   @override
//   Future<dynamic> getHeadApiResponse(String url,
//       {Map<String, String>? headers}) async {
//     try {
//       final response =
//       await http.head(Uri.parse(url), headers: headers ?? defaultHeaders);
//       return response.headers;
//     } on SocketException {
//       throw FetchDataExceptions("No Internet Connection");
//     }
//   }
//
//   // ✅ OPTIONS
//   @override
//   Future<dynamic> getOptionsApiResponse(String url,
//       {Map<String, String>? headers}) async {
//     try {
//       final request = http.Request('OPTIONS', Uri.parse(url));
//       request.headers.addAll(headers ?? defaultHeaders);
//       final streamed = await request.send();
//       final response = await http.Response.fromStream(streamed);
//       return returnResponse(response);
//     } on SocketException {
//       throw FetchDataExceptions("No Internet Connection");
//     }
//   }
//
//   // ✅ Multipart Upload
//   @override
//   Future<dynamic> getMultipartApiResponse(
//       String url,
//       Map<String, String> fields,
//       List<String> filePaths, {
//         Map<String, String>? headers,
//       }) async
//   {
//     try {
//       var request = http.MultipartRequest('POST', Uri.parse(url));
//       request.fields.addAll(fields);
//       request.headers.addAll(headers ?? {});
//
//       for (var path in filePaths) {
//         request.files.add(await http.MultipartFile.fromPath('file', path));
//       }
//
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
//       return returnResponse(response);
//     } on SocketException {
//       throw FetchDataExceptions("No Internet Connection");
//     }
//   }
//
//   // ✅ Form Data
//   @override
//   Future<dynamic> formPostApiResponse(String url, Map<String, dynamic> data,
//       {Map<String, String>? headers}) async {
//     try {
//       final request = http.MultipartRequest('POST', Uri.parse(url));
//
//       // Remove Content-Type (MultipartRequest will set boundary automatically)
//       final filteredHeaders = {...?headers};
//       filteredHeaders.remove('Content-Type');
//       if (filteredHeaders.isNotEmpty) {
//         request.headers.addAll(filteredHeaders);
//       }
//
//       bool isFileLike(dynamic v) {
//         if (v == null) return false;
//         if (v is File) return true;
//         try {
//           final p = v.path;
//           return p is String && p.isNotEmpty;
//         } catch (_) {
//           return false;
//         }
//       }
//
//       for (final entry in data.entries) {
//         final key = entry.key;
//         final value = entry.value;
//
//         if (value == null) continue;
//
//         if (isFileLike(value) && value is! List) {
//           final path = value.path;
//           final filename = path.split(Platform.pathSeparator).last;
//           request.files.add(await http.MultipartFile.fromPath(key, path, filename: filename));
//         } else if (value is List) {
//           for (final item in value) {
//             if (isFileLike(item)) {
//               final path = item.path;
//               final filename = path.split(Platform.pathSeparator).last;
//               request.files.add(await http.MultipartFile.fromPath(key, path, filename: filename));
//             } else {
//               request.fields.update(key, (v) => '$v,${item.toString()}',
//                   ifAbsent: () => item.toString());
//             }
//           }
//         } else {
//           request.fields[key] = value.toString();
//         }
//       }
//
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//
//       return returnResponse(response);
//     } on SocketException {
//       throw FetchDataExceptions("No Internet Connection");
//     } catch (_) {
//       rethrow;
//     }
//   }
//
//
//   // ✅ Stream / Real-Time
//   @override
//   Future<Stream<dynamic>> getStreamApiResponse(String url,
//       {Map<String, String>? headers}) async {
//     final client = http.Client();
//     try {
//       final request = http.Request('GET', Uri.parse(url));
//       request.headers.addAll(headers ?? defaultHeaders);
//       final response = await client.send(request);
//       return response.stream.transform(utf8.decoder);
//     } on SocketException {
//       throw FetchDataExceptions("No Internet Connection");
//     }
//   }
//
//   // ✅ File Download
//   @override
//   Future<dynamic> downloadFileApiResponse(String url, String savePath,
//       {Map<String, String>? headers}) async {
//     try {
//       final response = await http.get(Uri.parse(url), headers: headers);
//       if (response.statusCode == 200) {
//         final file = File(savePath);
//         await file.writeAsBytes(response.bodyBytes);
//         return {"status": true, "path": savePath};
//       } else {
//         throw FetchDataExceptions("Download Failed: ${response.statusCode}");
//       }
//     } on SocketException {
//       throw FetchDataExceptions("No Internet Connection");
//     }
//   }
//
//   // ✅ Central Response Handler
//   dynamic returnResponse(http.Response response) {
//     switch (response.statusCode) {
//       case 200:
//       case 201:
//         return jsonDecode(response.body);
//       case 204:
//         return {"message": "No Content"};
//       case 301:
//       case 302:
//         throw FetchDataExceptions("Redirected: ${response.headers['location']}");
//       case 400:
//         throw BadRequestException(response.body);
//       case 401:
//         throw UnauthorisedExceptions("Unauthorized Access");
//       case 403:
//         throw UnauthorisedExceptions("Forbidden");
//       case 404:
//         throw UserNotFoundException("URL Not Found: ${response.request?.url}");
//       case 408:
//         throw FetchDataExceptions("Request Timeout");
//       case 409:
//         throw BadRequestException("Conflict Detected");
//       case 415:
//         throw BadRequestException("Unsupported Media Type");
//       case 422:
//         throw BadRequestException("Validation Error: ${response.body}");
//       case 429:
//         throw FetchDataExceptions("Too Many Requests");
//       case 500:
//       case 502:
//       case 503:
//       case 504:
//         throw FetchDataExceptions("Server Error (${response.statusCode})");
//       default:
//         throw FetchDataExceptions(
//             "Unexpected Error: ${response.statusCode} - ${response.body}");
//     }
//   }
//
//
// }
