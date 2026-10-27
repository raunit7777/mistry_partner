
abstract class BaseApiServices {
  /// 🔹 GET Request (Fetch data)
  Future<dynamic> getGetApiResponse(String url);

  /// 🔹 POST Request (Create new data)
  Future<dynamic> getPostApiResponse(String url, dynamic data);

  /// 🔹 PUT Request (Update existing data completely)
  Future<dynamic> getPutApiResponse(String url, dynamic data);

  /// 🔹 PATCH Request (Partial update)
  Future<dynamic> getPatchApiResponse(String url, dynamic data);

  /// 🔹 DELETE Request (Remove data)
  Future<dynamic> getDeleteApiResponse(String url);

  Future<dynamic> formPostApiResponse(String url, Map<String, dynamic> data);
}
