// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyATGVMwWynYt4P0tK22oZDlw0O_wX_60Qs',
    appId: '1:183585370622:web:fac4ed6c22adc0656210af',
    messagingSenderId: '183585370622',
    projectId: 'test-auth-879c0',
    authDomain: 'test-auth-879c0.firebaseapp.com',
    storageBucket: 'test-auth-879c0.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABXmS56hEd4EA2KVpRCnCsuArLGokXzvA',
    appId: '1:183585370622:android:14394f9ce06c67106210af',
    messagingSenderId: '183585370622',
    projectId: 'test-auth-879c0',
    storageBucket: 'test-auth-879c0.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyATGVMwWynYt4P0tK22oZDlw0O_wX_60Qs',
    appId: '1:183585370622:web:1bd76f344e5197596210af',
    messagingSenderId: '183585370622',
    projectId: 'test-auth-879c0',
    authDomain: 'test-auth-879c0.firebaseapp.com',
    storageBucket: 'test-auth-879c0.firebasestorage.app',
  );
}
