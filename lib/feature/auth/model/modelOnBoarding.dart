class OnBoardingStatusModel {
  final bool profileStatus;
  final bool zoneStatus;
  final bool serviceStatus;
  final bool aadhaarStatus;
  final bool bankStatus;
  final bool allComplete;
  final String approvalStatus;

  OnBoardingStatusModel({
    required this.profileStatus,
    required this.zoneStatus,
    required this.serviceStatus,
    required this.aadhaarStatus,
    required this.bankStatus,
    required this.allComplete,
    required this.approvalStatus,
  });

  factory OnBoardingStatusModel.fromJson(Map<String, dynamic> json) {
    return OnBoardingStatusModel(
      profileStatus: json['profile_status'] ?? false,
      zoneStatus: json['zone_status'] ?? false,
      serviceStatus: json['service_status'] ?? false,
      aadhaarStatus: json['aadhaar_status'] ?? false,
      bankStatus: json['bank_status'] ?? false,
      allComplete: json['all_complete'] ?? false,
      approvalStatus: json['approval_status'] ?? '',
    );
  }
}