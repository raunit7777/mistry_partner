class TermModel {
  bool? status;
  String? message;
  Data? data;

  TermModel({this.status, this.message, this.data});

  TermModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // Yahan JSON bhej rahe hain
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  Policy? policy;

  Data({this.policy});

  Data.fromJson(Map<String, dynamic> json) {
    // FIX: API response mein nested data hai, isliye pehle nested 'data' check karenge
    final Map<String, dynamic>? source = json.containsKey('data')
        ? (json['data'] as Map<String, dynamic>)
        : json;

    policy = source?['policy'] != null ? Policy.fromJson(source!['policy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.policy != null) data['policy'] = this.policy!.toJson();
    return data;
  }
}

class Policy {
  int? id;
  String? title;
  String? slug;
  String? content;
  String? updatedAt;

  Policy({this.id, this.title, this.slug, this.content, this.updatedAt});

  Policy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    content = json['content'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'slug': slug, 'content': content, 'updated_at': updatedAt};
  }
}