
import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  static final _keyStr = '1234567890abcdefghijklmnopqrstuv'; 
  static final _ivStr  = 'abcdefghijklmnop'; 

  static final _key = Key.fromUtf8(_keyStr);
  static final _iv  = IV.fromUtf8(_ivStr);

  static String encrypt(String text) {
    print("ENCRYPT KEY LEN: ${_keyStr.length}, IV LEN: ${_ivStr.length}");
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  static String decrypt(String base64) {
    print("DECRYPT KEY LEN: ${_keyStr.length}, IV LEN: ${_ivStr.length}");
    final encrypter = Encrypter(AES(_key));
    final decrypted = encrypter.decrypt64(base64, iv: _iv);
    return decrypted;
  }
}
