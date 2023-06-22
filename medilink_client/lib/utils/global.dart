import 'dart:io';
const url = 'http://10.0.2.2:8800';
//const url = 'https://1a96-196-224-177-35.ngrok-free.app';
//const url = 'http://192.168.1.183:8800';

String? globalToken;
String? globalRole;
String? globalType;
String? globalUserId;
String? globalDeviceToken;

void setGlobaldeviceToken(String? notificationtoken) {
  globalDeviceToken = notificationtoken;
}

void setGlobalToken(String userToken) {
  globalToken = userToken;
}

void setGlobalRole(String userRole) {
  globalRole = userRole;
}

void setGlobalType(String userType) {
  globalType = userType;
}

void setGlobalUserId(String userId) async {
  globalUserId = userId;
}

getInternetConnection() async {
  try {
    var result = await InternetAddress.lookup("google.com");
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}
