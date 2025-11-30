import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatCryptoHelper {
  static Key _buildKey() {
    final raw = dotenv.env['CHAT_SECRET_KEY'] ?? 'change_this_chat_key';
    final padded = raw.padRight(32, '0');
    return Key.fromUtf8(padded.substring(0, 32));
  }

  static String encrypt(String plain) {
    if (plain.trim().isEmpty) return '';
    final key = _buildKey();
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plain, iv: iv);
    return '${iv.base64}|${encrypted.base64}';
  }

  static String decrypt(String cipher) {
    if (cipher.isEmpty) return '';
    final parts = cipher.split('|');
    if (parts.length != 2) return cipher;

    final iv = IV.fromBase64(parts[0]);
    final key = _buildKey();
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    try {
      return encrypter.decrypt64(parts[1], iv: iv);
    } catch (_) {
      return cipher;
    }
  }
}
