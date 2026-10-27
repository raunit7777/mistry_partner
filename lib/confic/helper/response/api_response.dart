import 'package:mishtry_partner/confic/helper/response/status.dart';
class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;
  int? statusCode;

  ApiResponse(this.status, this.data, this.message, {this.statusCode});

  ApiResponse.loading() : status = Status.LOADING;

  ApiResponse.completed(this.data, {this.statusCode}) : status = Status.COMPLETED;

  ApiResponse.error(this.message, {this.statusCode}) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data \n StatusCode : $statusCode";
  }
}
