// TODO: Configure Firebase for your platform
// This file will be generated when you run `flutterfire configure`

class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_AUTH_DOMAIN',
    databaseURL: 'YOUR_DATABASE_URL',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );
}

class FirebaseOptions {
  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String? authDomain;
  final String? databaseURL;
  final String? storageBucket;

  const FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.authDomain,
    this.databaseURL,
    this.storageBucket,
  });
}
