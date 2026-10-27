class BookingModel2 {
  final int bookingId;
  final String serviceName;
  final String specificTask;
  final double amount;
  final String pickupAddress;
  final String dropAddress;
  final String distance;

  BookingModel2({
    required this.bookingId,
    required this.serviceName,
    required this.specificTask,
    required this.amount,
    required this.pickupAddress,
    required this.dropAddress,
    required this.distance,
  });

  factory BookingModel2.fromJson(Map<String, dynamic> json) {
    return BookingModel2(
      bookingId: json['booking_id'] ?? 0,

      // JSON mein 'service' -> 'name' path sahi hai
      serviceName: json['service']?['name'] ?? "Service",

      // Agar JSON mein 'task_description' nahi hai, toh "No task" dikhayega
      specificTask: json['task_description'] ?? "No task description",

      // 'total_amount' double mein cast kiya
      amount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,

      // Pickup address agar nahi hai toh drop address ko pickup bana do
      pickupAddress: json['pickup_address'] ?? json['address'] ?? "No pickup",

      // 'address' hi drop address hai
      dropAddress: json['address'] ?? "No address",

      // 'distance' agar nahi hai toh default "0 km"
      distance: json['distance']?.toString() ?? "0 km",
    );
  }
}