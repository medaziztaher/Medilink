import 'package:firebase_messaging/firebase_messaging.dart';

import '../../utils/global.dart';

class FirebaseNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("notificationtoken : ${fCMToken}");
    setGlobaldeviceToken(fCMToken);
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Title : ${message.notification?.title}');
    print('body : ${message.notification?.body}');
    print('Payload: ${message.data}');
  }
  
}
