class OverVIewModel {
  bool? status;
  String? message;
  Data? data;

  OverVIewModel({this.status, this.message, this.data});

  OverVIewModel.fromJson(Map<String, dynamic> json) {
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
  Stats? stats;

  Data({this.stats});

  Data.fromJson(Map<String, dynamic> json) {
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stats != null) {
      data['stats'] = this.stats!.toJson();
    }
    return data;
  }
}

class Stats {
  int? totalEarning;
  int? netEarning;
  int? cashCollected;
  int? onlinePaid;
  int? adminDue;
  int? platformFees;
  int? wallet;
  int? totalAssigned;
  int? jobsCompleted;
  int? inProgress;
  int? cancelled;
  int? rating;
  int? ratingCount;
  int? acceptanceRate;

  Stats(
      {this.totalEarning,
        this.netEarning,
        this.cashCollected,
        this.onlinePaid,
        this.adminDue,
        this.platformFees,
        this.wallet,
        this.totalAssigned,
        this.jobsCompleted,
        this.inProgress,
        this.cancelled,
        this.rating,
        this.ratingCount,
        this.acceptanceRate});

  Stats.fromJson(Map<String, dynamic> json) {
    totalEarning = json['total_earning'];
    netEarning = json['net_earning'];
    cashCollected = json['cash_collected'];
    onlinePaid = json['online_paid'];
    adminDue = json['admin_due'];
    platformFees = json['platform_fees'];
    wallet = json['wallet'];
    totalAssigned = json['total_assigned'];
    jobsCompleted = json['jobs_completed'];
    inProgress = json['in_progress'];
    cancelled = json['cancelled'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    acceptanceRate = json['acceptance_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_earning'] = this.totalEarning;
    data['net_earning'] = this.netEarning;
    data['cash_collected'] = this.cashCollected;
    data['online_paid'] = this.onlinePaid;
    data['admin_due'] = this.adminDue;
    data['platform_fees'] = this.platformFees;
    data['wallet'] = this.wallet;
    data['total_assigned'] = this.totalAssigned;
    data['jobs_completed'] = this.jobsCompleted;
    data['in_progress'] = this.inProgress;
    data['cancelled'] = this.cancelled;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    data['acceptance_rate'] = this.acceptanceRate;
    return data;
  }
}
