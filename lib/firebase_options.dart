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
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA1u7ePBRvCLRQT9mSXSCfWeM-2pQIhtCo',
    appId: '1:178640045744:web:31762843c28d6c81f71d75',
    messagingSenderId: '178640045744',
    projectId: 'retal-car',
    authDomain: 'retal-car.firebaseapp.com',
    storageBucket: 'retal-car.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJLdvD8PYsn2OkPdZlORPTdydzw2lbw_c',
    appId: '1:178640045744:android:a6d1e5a0701fe9edf71d75',
    messagingSenderId: '178640045744',
    projectId: 'retal-car',
    storageBucket: 'retal-car.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4xT5B8P8hfNM72XaqAdJNzp8wgu8nLVQ',
    appId: '1:178640045744:ios:659fb5dfbd7c37f2f71d75',
    messagingSenderId: '178640045744',
    projectId: 'retal-car',
    storageBucket: 'retal-car.firebasestorage.app',
    iosBundleId: 'com.example.car',
  );
}