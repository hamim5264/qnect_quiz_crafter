import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmailOtpSender {
  static String _generateOtp() {
    final rand = Random();
    return (1000 + rand.nextInt(9000)).toString();
  }

  static Future<bool> sendOtpToEmail({
    required String userEmail,
    required String userName,
  }) async {
    final otp = _generateOtp();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('generatedOtp', otp);
    await prefs.setInt(
      'otpExpiry',
      DateTime.now().add(const Duration(minutes: 2)).millisecondsSinceEpoch,
    );

    final sendUntil =
        "${DateTime.now().hour}:${(DateTime.now().minute + 2) % 60}";

    final serviceId = dotenv.env['EMAILJS_SERVICE_ID'];
    final templateId = dotenv.env['EMAILJS_TEMPLATE_ID'];
    final publicKey = dotenv.env['EMAILJS_PUBLIC_KEY'];

    if (serviceId == null || templateId == null || publicKey == null) {
      print("❌ EmailJS credentials missing in .env");
      return false;
    }

    final response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {
        'Content-Type': 'application/json',
        'origin': 'http://localhost',
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          'user_name': userName,
          'user_email': userEmail,
          'passcode': otp,
          'time': sendUntil,
        },
      }),
    );

    print("📨 EmailJS Status: ${response.statusCode}");
    print("📨 Body: ${response.body}");

    return response.statusCode == 200;
  }

  static Future<bool> verifyOtp(String inputOtp) async {
    final prefs = await SharedPreferences.getInstance();
    final savedOtp = prefs.getString('generatedOtp');
    final expiry = prefs.getInt('otpExpiry') ?? 0;

    final now = DateTime.now().millisecondsSinceEpoch;

    return (inputOtp == savedOtp) && (now <= expiry);
  }
}
