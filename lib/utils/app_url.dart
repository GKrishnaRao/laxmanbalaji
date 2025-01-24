class AppUrl {
  //TEST URL
  // static const String liveBaseURL = "https://srv676232.hstgr.cloud/api/";

  //Live URL
  static const String liveBaseURL = "https://srv676232.hstgr.cloud/api/";

  static const String baseURL = liveBaseURL;

  static const String liveFaceRegisterURL = "http://82.112.230.225:5000/api/";
  static const String globalFaceRegister =
      "${liveFaceRegisterURL}uploadfaceregister";
  static const String globalFaceSignIn =
      "${liveFaceRegisterURL}comparefaceofuser";

  //Webservices URL
  static const String globalRegisterInviteUrl = "${baseURL}developer-invite/";
  static const String globalProfileImgURLThumbs =
      "${baseURL}media/backend/userfiles/";
  static const String globalDwg = "${baseURL}media/backend/images/drawing/";

  static const String checkForceUpdate = "${baseURL}ws-force-update-popup";
  static const String loginOtpRequest = "${baseURL}ws-mobile-no-exit";
  static const String verifyOtpRequest =
      "${baseURL}ws-mobile-no-with-otp-login";
  static const String webgetProfile = "${baseURL}ws-employee-profile-details";
  static const String webgetBankDetails = "${baseURL}ws-employee-bank-details";
  static const String webEmployeeCheckIn =
      "${baseURL}ws-employee-attandance-checkin";
  static const String webEmployeeCheckOut =
      "${baseURL}ws-employee-attandance-checkout";
  static const String webGetDashboardDetails =
      "${baseURL}ws-employee-dashboard";
  static const String webGetMonthlyAttendanceDetails =
      "${baseURL}ws-employee-monthly-attandance";
  static const String webGetParticularDayDetails =
      "${baseURL}ws-employee-attandance-details";
  static const String webGetSalarySlipDetails =
      "${baseURL}ws-employee-salary-details";
}

extension StringExtension on String {
  String capitalizeWords() {
    if (isEmpty) {
      return this;
    }
    return split(' ')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }
}
