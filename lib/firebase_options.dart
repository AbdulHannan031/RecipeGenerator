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
    apiKey: 'AIzaSyBbELCg5XGNJ5KScPtRiHZl_gopMfD88gI',
    appId: '1:233024386245:web:1c99d5fe4f232de52cacac',
    messagingSenderId: '233024386245',
    projectId: 'recipe-generator-d2b1d',
    authDomain: 'recipe-generator-d2b1d.firebaseapp.com',
    storageBucket: 'recipe-generator-d2b1d.appspot.com',
    measurementId: 'G-8HGG058343',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB75B_BAri3cmarbMZItZR0hOaM9_kwxlc',
    appId: '1:233024386245:android:94a99daa757a2c852cacac',
    messagingSenderId: '233024386245',
    projectId: 'recipe-generator-d2b1d',
    storageBucket: 'recipe-generator-d2b1d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOFZAkDP-l_8ewpywFxYdw0ipVQKIZWHQ',
    appId: '1:233024386245:ios:49313d7283dc23a32cacac',
    messagingSenderId: '233024386245',
    projectId: 'recipe-generator-d2b1d',
    storageBucket: 'recipe-generator-d2b1d.appspot.com',
    iosBundleId: 'com.example.myapp',
  );
}