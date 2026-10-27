class BookingModel {
  bool? status;
  String? message;
  Data? data;

  BookingModel({this.status, this.message, this.data});

  BookingModel.fromJson(Map<String, dynamic> json) {
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
  List<Bookings>? bookings;

  Data({this.bookings});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(new Bookings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookings != null) {
      data['bookings'] = this.bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bookings {
  int? id;
  int? userId;
  int? serviceId;
  int? workerId;
 dynamic zoneId;
  String? bookingDate;
 dynamic notes;
  String? address;
  int? addressId;
  int? slotId;
 dynamic couponId;
 dynamic couponCode;
  String? couponDiscount;
  String? status;
  String? amount;
  String? platformCharge;
  String? gstAmount;
  String? totalAmount;
  String? paymentStatus;
  String? paymentId;
  String? cfOrderId;
  String? paymentMethod;
  String? codCollected;
  String? adminDue;
  String? createdAt;
  String? updatedAt;
  User? user;
  Service? service;

  Bookings(
      {this.id,
        this.userId,
        this.serviceId,
        this.workerId,
        this.zoneId,
        this.bookingDate,
        this.notes,
        this.address,
        this.addressId,
        this.slotId,
        this.couponId,
        this.couponCode,
        this.couponDiscount,
        this.status,
        this.amount,
        this.platformCharge,
        this.gstAmount,
        this.totalAmount,
        this.paymentStatus,
        this.paymentId,
        this.cfOrderId,
        this.paymentMethod,
        this.codCollected,
        this.adminDue,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.service});

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    serviceId = json['service_id'];
    workerId = json['worker_id'];
    zoneId = json['zone_id'];
    bookingDate = json['booking_date'];
    notes = json['notes'];
    address = json['address'];
    addressId = json['address_id'];
    slotId = json['slot_id'];
    couponId = json['coupon_id'];
    couponCode = json['coupon_code'];
    couponDiscount = json['coupon_discount'];
    status = json['status'];
    amount = json['amount'];
    platformCharge = json['platform_charge'];
    gstAmount = json['gst_amount'];
    totalAmount = json['total_amount'];
    paymentStatus = json['payment_status'];
    paymentId = json['payment_id'];
    cfOrderId = json['cf_order_id'];
    paymentMethod = json['payment_method'];
    codCollected = json['cod_collected'];
    adminDue = json['admin_due'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    service =
    json['Service'] != null ? new Service.fromJson(json['Service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['service_id'] = this.serviceId;
    data['worker_id'] = this.workerId;
    data['zone_id'] = this.zoneId;
    data['booking_date'] = this.bookingDate;
    data['notes'] = this.notes;
    data['address'] = this.address;
    data['address_id'] = this.addressId;
    data['slot_id'] = this.slotId;
    data['coupon_id'] = this.couponId;
    data['coupon_code'] = this.couponCode;
    data['coupon_discount'] = this.couponDiscount;
    data['status'] = this.status;
    data['amount'] = this.amount;
    data['platform_charge'] = this.platformCharge;
    data['gst_amount'] = this.gstAmount;
    data['total_amount'] = this.totalAmount;
    data['payment_status'] = this.paymentStatus;
    data['payment_id'] = this.paymentId;
    data['cf_order_id'] = this.cfOrderId;
    data['payment_method'] = this.paymentMethod;
    data['cod_collected'] = this.codCollected;
    data['admin_due'] = this.adminDue;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    if (this.service != null) {
      data['Service'] = this.service!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? mobile;

  User({this.id, this.name, this.mobile});

  User.fromJson(Map<String, dynamic> json) {
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

class Service {
  int? id;
  String? name;
  String? description;
  String? estimatedTime;
  String? price;

  Service(
      {this.id, this.name, this.description, this.estimatedTime, this.price});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    estimatedTime = json['estimated_time'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['estimated_time'] = this.estimatedTime;
    data['price'] = this.price;
    return data;
  }
}
