import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../firebase/api/authentififcation.dart';


class MailVerficationController extends GetxController{
  late Timer timer;
  @override
  void onInit(){
    super.onInit();
    sendVerificationEmail();
    setTimerForAutoRedirect();
  }

  Future<void> sendVerificationEmail()async{
    try{
     await Auth.instance.sendEmailVeriffication();
    }catch(e){
      print(e);
    }
  } 

  void setTimerForAutoRedirect(){
    timer = Timer.periodic(Duration(seconds:3), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user =FirebaseAuth.instance.currentUser;
      if(user!.emailVerified){
        timer.cancel();
        Auth.instance.setInitialsignupScreen(user);
      }
    });
  }
  void manuallyCheckEmailVerificationStatus(){
      FirebaseAuth.instance.currentUser?.reload();
 final user =FirebaseAuth.instance.currentUser;
  if(user!.emailVerified){
        Auth.instance.setInitialsignupScreen(user);
  }
  }

}