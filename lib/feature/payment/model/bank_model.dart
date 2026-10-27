class BankModel {
  bool? status;
  String? message;
  Data? data;

  BankModel({this.status, this.message, this.data});

  BankModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? bankName;
  String? holderName;
  String? accountNumber;
  String? ifscCode;

  Data({this.bankName, this.holderName, this.accountNumber, this.ifscCode});

  Data.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'];
    holderName = json['holder_name'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_name'] = this.bankName;
    data['holder_name'] = this.holderName;
    data['account_number'] = this.accountNumber;
    data['ifsc_code'] = this.ifscCode;
    return data;
  }
}
