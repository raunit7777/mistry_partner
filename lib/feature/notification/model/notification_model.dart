class NotificationModel {
  bool? status;
  String? message;
  Data? data;

  NotificationModel({this.status, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Notifications>? notifications;
  int? unreadCount;

  Data({this.notifications, this.unreadCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
    unreadCount = json['unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notifications != null) {
      data['notifications'] =
          notifications!.map((v) => v.toJson()).toList();
    }
    data['unread_count'] = unreadCount;
    return data;
  }
}

class Notifications {
  int? id;
  int? userId;
  int? workerId;
  String? title;
  String? body;
  String? type;
  bool? isRead;
  String? data;
  String? createdAt;
  String? updatedAt;

  Notifications(
      {this.id,
        this.userId,
        this.workerId,
        this.title,
        this.body,
        this.type,
        this.isRead,
        this.data,
        this.createdAt,
        this.updatedAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    workerId = json['worker_id'];
    title = json['title'];
    body = json['body'];
    type = json['type'];
    isRead = json['is_read'];
    data = json['data'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['worker_id'] = workerId;
    data['title'] = title;
    data['body'] = body;
    data['type'] = type;
    data['is_read'] = isRead;
    data['data'] = this.data;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
