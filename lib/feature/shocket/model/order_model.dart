class OrderModel {
  bool? status;
  String? message;
  Data? data;

  OrderModel({this.status, this.message, this.data});

  OrderModel.fromJson(Map<String, dynamic> json) {
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
  Ongoing? ongoing;

  Data({this.ongoing});

  Data.fromJson(Map<String, dynamic> json) {
    ongoing =
    json['ongoing'] != null ? new Ongoing.fromJson(json['ongoing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ongoing != null) {
      data['ongoing'] = this.ongoing!.toJson();
    }
    return data;
  }
}

class Ongoing {
  String? type;
  int? bookingId;
  Service? service;
  String? taskDescription;
  double? totalAmount;
  String? address;
  String? userLet;
  String? userLng;
  String? pickupAddress;
  String? distance;
  String? bookingDate;
  String? createdAt;
  String? status;
  Customer? customer;

  Ongoing(
      {this.type,
        this.bookingId,
        this.service,
        this.taskDescription,
        this.totalAmount,
        this.address,
        this.userLet,
        this.userLng,
        this.pickupAddress,
        this.distance,
        this.bookingDate,
        this.createdAt,
        this.status,
        this.customer});

  Ongoing.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    bookingId = json['booking_id'];
    service =
    json['service'] != null ? new Service.fromJson(json['service']) : null;
    taskDescription = json['task_description'];
    totalAmount = json['total_amount'];
    address = json['address'];
    userLet = json['userLet'];
    userLng = json['userLng'];
    pickupAddress = json['pickup_address'];
    distance = json['distance'];
    bookingDate = json['booking_date'];
    createdAt = json['created_at'];
    status = json['status'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['booking_id'] = this.bookingId;
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    data['task_description'] = this.taskDescription;
    data['total_amount'] = this.totalAmount;
    data['address'] = this.address;
    data['userLet'] = this.userLet;
    data['userLng'] = this.userLng;
    data['pickup_address'] = this.pickupAddress;
    data['distance'] = this.distance;
    data['booking_date'] = this.bookingDate;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class Service {
  int? id;
  String? name;
  int? price;

  Service({this.id, this.name, this.price});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class Customer {
  int? id;
  String? name;
  String? mobile;

  Customer({this.id, this.name, this.mobile});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    return data;
  }
}
