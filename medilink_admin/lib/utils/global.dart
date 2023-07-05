import 'dart:io';


//const url = 'https://3f80-197-27-237-126.ngrok-free.app';

const url = 'http://10.0.2.2:8800';
//const url = 'http://192.168.137.1:8800';

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

void setGlobalUserId(String userId) async{
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
