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
        return macos;
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
    apiKey: 'AIzaSyA-RZ1faJzCP1c8Elp9rAhChcsHkPHY7XQ',
    appId: '1:964091017306:web:e9e94b6daa83c1c0a9c063',
    messagingSenderId: '964091017306',
    projectId: 'lumi-2883e',
    authDomain: 'lumi-2883e.firebaseapp.com',
    storageBucket: 'lumi-2883e.firebasestorage.app',
    measurementId: 'G-NJNPKHTJTP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwZPnfmYr4Rvpln395MN0kkS_6tYWvzCE',
    appId: '1:964091017306:android:1e3812d264f2f157a9c063',
    messagingSenderId: '964091017306',
    projectId: 'lumi-2883e',
    storageBucket: 'lumi-2883e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBF-ibZUR0SJXNnRLZ3TPqJXre4FRv7Idw',
    appId: '1:964091017306:ios:a5dc50b09ff80507a9c063',
    messagingSenderId: '964091017306',
    projectId: 'lumi-2883e',
    storageBucket: 'lumi-2883e.firebasestorage.app',
    iosBundleId: 'com.example.dsiApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBF-ibZUR0SJXNnRLZ3TPqJXre4FRv7Idw',
    appId: '1:964091017306:ios:a5dc50b09ff80507a9c063',
    messagingSenderId: '964091017306',
    projectId: 'lumi-2883e',
    storageBucket: 'lumi-2883e.firebasestorage.app',
    iosBundleId: 'com.example.dsiApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-RZ1faJzCP1c8Elp9rAhChcsHkPHY7XQ',
    appId: '1:964091017306:web:ebf0cc723731becca9c063',
    messagingSenderId: '964091017306',
    projectId: 'lumi-2883e',
    authDomain: 'lumi-2883e.firebaseapp.com',
    storageBucket: 'lumi-2883e.firebasestorage.app',
    measurementId: 'G-WHYRYVJMJT',
  );

}