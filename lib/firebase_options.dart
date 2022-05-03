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
    apiKey: 'AIzaSyDL72r3jsCb2pJrzqXtpCNP6O5e3Gb5uPk',
    appId: '1:482193828529:web:0d4332addb820309a09090',
    messagingSenderId: '482193828529',
    projectId: 'chat-app-levels',
    authDomain: 'chat-app-levels.firebaseapp.com',
    storageBucket: 'chat-app-levels.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlhsmVWwt9ju9i8rJFBCj5tN3Wmm3RERE',
    appId: '1:482193828529:android:c06cb0a00513db5aa09090',
    messagingSenderId: '482193828529',
    projectId: 'chat-app-levels',
    storageBucket: 'chat-app-levels.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1QQ5wSU0w4THg9AGH4XWBOBS-SikOtUk',
    appId: '1:482193828529:ios:c699d61c5ea11b32a09090',
    messagingSenderId: '482193828529',
    projectId: 'chat-app-levels',
    storageBucket: 'chat-app-levels.appspot.com',
    iosClientId: '482193828529-o52e7c2q2epcb9brmemm1sq3o3tvkbup.apps.googleusercontent.com',
    iosBundleId: 'com.levels.chatApp',
  );
}
