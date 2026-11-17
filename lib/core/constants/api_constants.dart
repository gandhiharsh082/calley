class ApiConstants {
  static const String host = '10.0.2.2';
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';

  // Lists
  static const String lists = '/list'; // GET /list?userId=<id>
  static String listDetails(String listId) => '/list/$listId';
}
