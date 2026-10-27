class AppUrl{

  static var baseUrl = "https://mishtiry.giftaura.shop/";
  static var baseUrlImg = "https://mishtiry.giftaura.shop/uploads/";
  static var verifyUrl = "${baseUrl}api/";
  static var login = "${verifyUrl}worker/auth/send-otp";
  static var otpVerify = "${verifyUrl}worker/auth/verify-otp";
  static var zone = "${verifyUrl}worker/zones";
  static var service = "${verifyUrl}worker/services";
  static var selectzone = "${verifyUrl}worker/zone";
  static var servicesUpdate = "${verifyUrl}worker/my-services";
  static var workerAadhar = "${verifyUrl}worker/aadhaar";
  static var profile = "${verifyUrl}worker/profile";
  static var online = "${verifyUrl}worker/availability";
  static var booking = "${verifyUrl}worker/bookings?";
  static var booking2 = "${verifyUrl}worker/ongoing-booking";
  static var notificationList = "${verifyUrl}worker/notifications";
  static var profileUpdate = "${verifyUrl}worker/profile";
  static var orderComplete = "${verifyUrl}worker/bookings/";
  static var readNotification = "${verifyUrl}worker/notifications/read-all";
  static var deleteNotification  = "${verifyUrl}/worker/notifications/";
  static var getBank  = "${verifyUrl}/worker/bank-details";
  static var addOn  = "${verifyUrl}/worker/bookings/";
  static var dashBord  = "${verifyUrl}/worker/dashboard/today";
  static var getDashBord  = "${verifyUrl}/worker/dashboard/stats";
  static var getAddon  = "${verifyUrl}/worker/bookings/";
  static var policies  = "${verifyUrl}user/policies";
  static var policiesData  = "${verifyUrl}user/policies/";
  static var onboarding  = "${verifyUrl}worker/onboarding-status";

}
