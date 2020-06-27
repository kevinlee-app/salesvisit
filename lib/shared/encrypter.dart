import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class SVEncrypter {
  final key = Key.fromUtf8('SBIJ4Y4S3L4LU...................');
  final iv = IV.fromLength(16);

  String encrypt(String data) {
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(data, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print("COPY THIS : " + encrypted.base64);

    return encrypted.base64;
  }

  String decrypt(String data) {
    final encrypter = Encrypter(AES(key));

    final encrypted = Encrypted.fromBase64(data);
    
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
