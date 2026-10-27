class PolicesModel {
  bool? status;
  String? message;
  Data? data;

  PolicesModel({this.status, this.message, this.data});

  PolicesModel.fromJson(Map<String, dynamic> json) {
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
  List<Policies>? policies;

  Data({this.policies});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['policies'] != null) {
      policies = <Policies>[];
      json['policies'].forEach((v) {
        policies!.add(new Policies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.policies != null) {
      data['policies'] = this.policies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Policies {
  int? id;
  String? title;
  String? slug;
  String? icon;

  Policies({this.id, this.title, this.slug, this.icon});

  Policies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['icon'] = this.icon;
    return data;
  }
}
