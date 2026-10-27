class ProfileModel {
  bool? status;
  String? message;
  Data? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  Worker? worker;

  Data({this.worker});

  Data.fromJson(Map<String, dynamic> json) {
    worker =
    json['worker'] != null ? new Worker.fromJson(json['worker']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.worker != null) {
      data['worker'] = this.worker!.toJson();
    }
    return data;
  }
}

class Worker {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? profileImage;
  int? zoneId;
  String? status;
  String? wallet;
  String? rating;
  int? ratingCount;
  String? availability;
  String? latitude;
  String? longitude;
  String? aadhaarNumber;
  String? aadhaarFront;
  String? aadhaarBack;
  bool? isActive;
  String? createdAt;
  Zone? zone;
  List<Services>? services;

  Worker(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.profileImage,
        this.zoneId,
        this.status,
        this.wallet,
        this.rating,
        this.ratingCount,
        this.availability,
        this.latitude,
        this.longitude,
        this.aadhaarNumber,
        this.aadhaarFront,
        this.aadhaarBack,
        this.isActive,
        this.createdAt,
        this.zone,
        this.services});

  Worker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    profileImage = json['profile_image'];
    zoneId = json['zone_id'];
    status = json['status'];
    wallet = json['wallet'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    availability = json['availability'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    aadhaarNumber = json['aadhaar_number'];
    aadhaarFront = json['aadhaar_front'];
    aadhaarBack = json['aadhaar_back'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    zone = json['Zone'] != null ? new Zone.fromJson(json['Zone']) : null;
    if (json['Services'] != null) {
      services = <Services>[];
      json['Services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    data['zone_id'] = this.zoneId;
    data['status'] = this.status;
    data['wallet'] = this.wallet;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    data['availability'] = this.availability;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['aadhaar_number'] = this.aadhaarNumber;
    data['aadhaar_front'] = this.aadhaarFront;
    data['aadhaar_back'] = this.aadhaarBack;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    if (this.zone != null) {
      data['Zone'] = this.zone!.toJson();
    }
    if (this.services != null) {
      data['Services'] = this.services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Zone {
  int? id;
  String? name;

  Zone({this.id, this.name});

  Zone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Services {
  int? id;
  String? name;
  String? price;

  Services({this.id, this.name, this.price});

  Services.fromJson(Map<String, dynamic> json) {
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
