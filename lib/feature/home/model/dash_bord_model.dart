class DashbordModel {
  bool? status;
  String? message;
  Data? data;

  DashbordModel({this.status, this.message, this.data});

  DashbordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // Yahan JSON bhej rahe hain
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  Today? today;

  Data({this.today});

  Data.fromJson(Map<String, dynamic> json) {
    // FIX: Agar 'data' key ke andar ek aur 'data' key hai, toh use access karo
    final Map<String, dynamic> actualData = json.containsKey('data')
        ? (json['data'] as Map<String, dynamic>)
        : json;

    today = actualData['today'] != null ? new Today.fromJson(actualData['today']) : null;
  }
}

class Today {
  dynamic earning;
  dynamic jobsDone;
  dynamic rating;
  dynamic ratingCount;

  Today({this.earning, this.jobsDone, this.rating, this.ratingCount});

  Today.fromJson(Map<String, dynamic> json) {
    earning = json['earning'];
    jobsDone = json['jobs_done'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
  }
}