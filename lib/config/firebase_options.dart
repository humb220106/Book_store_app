// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for this Firebase project.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Web configuration
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios; // same as iOS
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Android configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEjb1p1m1kTP9JPbO5hyd_M_ovUgAof2A',
    appId: '1:835687520150:android:710fe0913ac803f8172fb7',
    messagingSenderId: '835687520150',
    projectId: 'bookapp-20360',
    storageBucket: 'bookapp-20360.firebasestorage.app',
  );

  // iOS configuration (replace with your actual values if iOS exists)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_IOS_MESSAGING_SENDER_ID',
    projectId: 'bookapp-20360',
    storageBucket: 'bookapp-20360.firebasestorage.app',
    iosBundleId: 'com.book_store_app',
  );

  // Web configuration (optional, if you plan to support web)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBEjb1p1m1kTP9JPbO5hyd_M_ovUgAof2A',
    appId: '1:835687520150:web:710fe0913ac803f8172fb7',
    messagingSenderId: '835687520150',
    projectId: 'bookapp-20360',
    storageBucket: 'bookapp-20360.firebasestorage.app',
    authDomain: 'bookapp-20360.firebaseapp.com',
    measurementId: 'G-MEASUREMENT_ID', // optional
  );
}
