class ZoneResponse {
  final bool status;
  final String message;
  final ZoneData data;

  ZoneResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ZoneResponse.fromJson(Map<String, dynamic> json) {
    return ZoneResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ZoneData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ZoneData {
  final List<Zone> zones;

  ZoneData({required this.zones});

  factory ZoneData.fromJson(Map<String, dynamic> json) {
    return ZoneData(
      zones: (json['zones'] as List<dynamic>?)
          ?.map((e) => Zone.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zones': zones.map((e) => e.toJson()).toList(),
    };
  }
}

class Zone {
  final int id;
  final String name;

  Zone({
    required this.id,
    required this.name,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}