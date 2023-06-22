import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../settings/path.dart';
import '../../widgets/complete_profile/complete_profile.dart';
import '../../widgets/email_verification/email_verification_screen.dart';
import '../exceptions/signup.dart';

class Auth extends GetxController {
  static Auth get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  late final User? currentUser;
  var verificationId = ''.obs;

  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
  }

  /*setInitialLoginScreen(User? user) async {
    user!.emailVerified
        ? Get.offAll(() => SearchScreen())
        : Get.offAll(() => MailVerfication());
  }*/

  setInitialsignupScreen(User? user) async {
    user!.emailVerified
        ? Get.offAll(() => CompleteProfileScreen())
        : Get.offAll(() => MailVerfication());
    print("${firebaseUser.value}");
  }

  Future<http.Response?> createUser(
      String email, String password, Map<String, dynamic> body) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (firebaseUser.value != null) {
        final response = await http.post(
          Uri.parse(signup),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(body),
        );
        if (response.statusCode != 201) {
          await _auth.currentUser!.delete();
          print('User deleted successfully.');
        }
        return response;
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignupFailure(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      final ex = SignupFailure();
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }
    return null;
  }

  /*Future<http.Response?> signIn(
      String email, String password, Map<String, dynamic> body) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final response = await http.post(
        Uri.parse(login),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );
      print(response);
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }*/

  Future<void> sendEmailVeriffication() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print('$e.code');
    } catch (e) {
      print(e);
    }
  }

  Future<void> phoneauth(String phoneno) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneno,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          print(e);
        },
        codeSent: ((verificationId, forceResendingToken) {
          this.verificationId.value = verificationId;
        }),
        codeAutoRetrievalTimeout: ((verificationId) {
          this.verificationId.value = verificationId;
        }));
  }

  Future<bool> verifyOtp(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }

  Future<void> logout() async => await _auth.signOut();
}
