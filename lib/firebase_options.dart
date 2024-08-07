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
    apiKey: 'AIzaSyDQb68QlmVxSsJqv7OMziYtNRtp0CJmuGk',
    appId: '1:605592584551:web:b0697be7760460569a2fc2',
    messagingSenderId: '605592584551',
    projectId: 'grokci-6f967',
    authDomain: 'grokci-6f967.firebaseapp.com',
    storageBucket: 'grokci-6f967.appspot.com',
    measurementId: 'G-L2Z8CJWCMQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlP-2nJPQYvJd_mByIgiiDlXjpIwLqIHk',
    appId: '1:605592584551:android:985fa778acaea12d9a2fc2',
    messagingSenderId: '605592584551',
    projectId: 'grokci-6f967',
    storageBucket: 'grokci-6f967.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeprxf0u9R_XkIvT1V8WZDFtQeBH0nUfE',
    appId: '1:605592584551:ios:07ab00b9df6dde899a2fc2',
    messagingSenderId: '605592584551',
    projectId: 'grokci-6f967',
    storageBucket: 'grokci-6f967.appspot.com',
    iosBundleId: 'com.example.grokciMain',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDeprxf0u9R_XkIvT1V8WZDFtQeBH0nUfE',
    appId: '1:605592584551:ios:07ab00b9df6dde899a2fc2',
    messagingSenderId: '605592584551',
    projectId: 'grokci-6f967',
    storageBucket: 'grokci-6f967.appspot.com',
    iosBundleId: 'com.example.grokciMain',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDQb68QlmVxSsJqv7OMziYtNRtp0CJmuGk',
    appId: '1:605592584551:web:9e48a80cb837f5db9a2fc2',
    messagingSenderId: '605592584551',
    projectId: 'grokci-6f967',
    authDomain: 'grokci-6f967.firebaseapp.com',
    storageBucket: 'grokci-6f967.appspot.com',
    measurementId: 'G-Y3G5634S41',
  );

}