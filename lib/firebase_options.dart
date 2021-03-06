// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC09KVsVnpb6ib_fpuFYWLTO87LJhH773E',
    appId: '1:240868848983:web:b9dac5a75f9e2063cefa12',
    messagingSenderId: '240868848983',
    projectId: 'shani-flutter-mynotes',
    authDomain: 'shani-flutter-mynotes.firebaseapp.com',
    storageBucket: 'shani-flutter-mynotes.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBYUqvVVQL62G6slvdXpaZwFZyulr_ogic',
    appId: '1:240868848983:android:f6e345f3a61dd43ecefa12',
    messagingSenderId: '240868848983',
    projectId: 'shani-flutter-mynotes',
    storageBucket: 'shani-flutter-mynotes.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNwLo2hCIyd3xUHlfUPyJB7aVGhH0IbVE',
    appId: '1:240868848983:ios:41ec3a7e0209fd2acefa12',
    messagingSenderId: '240868848983',
    projectId: 'shani-flutter-mynotes',
    storageBucket: 'shani-flutter-mynotes.appspot.com',
    iosClientId: '240868848983-kk5bolv8k9vn79rgukvn1gqup2cuefmk.apps.googleusercontent.com',
    iosBundleId: 'in.shani.mynotes',
  );
}
