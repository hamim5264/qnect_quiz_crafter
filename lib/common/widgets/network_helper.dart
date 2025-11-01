import 'dart:io';

class NetworkHelper {
  static Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup(
        'www.google.com',
      ).timeout(const Duration(seconds: 3));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
