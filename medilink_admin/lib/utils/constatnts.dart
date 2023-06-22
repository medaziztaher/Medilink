import 'package:flutter/material.dart';
import 'package:medilink_admin/utils/size_config.dart';


//Colors
const kPrimaryColor = Color.fromARGB(255, 67, 186, 255);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const kAnimationDuration = Duration(milliseconds: 200);
final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);
final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);
OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}

//Sharedprefs
const String kTokenSave = 'ktokensave';
const String kLangSave = 'klangsave';
const String kToken = 'Token';
//OTP 


//Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
//english
const String kEmailNullErrorEn = "Please Enter your email";
const String kInvalidEmailErrorEn = "Please Enter Valid Email";
const String kPassNullErrorEn = "Please Enter your password";
const String kShortPassErrorEn = "Password is too short";
const String kconfirmPassNullErrorEn = 'Please enter re-password';
const String kMatchPassErrorEn = "password do not match";
const String kNamelNullErrorEn = "Please Enter your name";
const String kFirstNamelNullErrorEn = "Please Enter your firstname";
const String kLastNamelNullErrorEn = "Please Enter your lastname";
const String kTypeNullErrorEn = "Please Enter the type field";
const String kPhoneNumberNullErrorEn = "Please Enter your phone number";
const String kAddressNullErrorEn = "Please Enter your address";
const String kRoleNullErrorEn = "Please Enter your role ";
const String kGenderNullErrorEn = "Please Enter your Gender ";
const String kNamevalidationErrorEn =
    'Please enter a valid name (letters only)';
const String kPhoneNumberValidationEn = 'Please enter a valid phone number';
const String kbirthdateValidationEn = 'Please enter a valid birthdate';
const String kSpecializationNullErrorEn =
    "Please Enter a valid specialization ";
const String kdescriptionvalidationEn = "Please Enter less then 3 lines ";
const String kLanguageScreenEn = "Select your language";
const String kEnglishEn = "English";
const String kFrenchEn = "French";
const String kArabicEn = "Arabic";
const String kbutton1En = "Next";
const String ksplash1En = "Welcome to Medilink";
const String ksplash2En = "We help people connect with their doctors";
const String ksplash3En =
    "We show how to easily monitor \nyour medical conditions";
const String ksigninEn = "Sign In";
const String kwelcomeEn = "Welcome Back";
const String kcontinueEn =
    "Sign in with your email and password  \nor continue with social media";
const String knoacountEn = "Don't have  an account!";
const String ksignupEn = "Sign Up";
const String kerror1En = 'Unable to connect to the server.\n Please try again.';
const String kerror2En = 'An unexpected error occurred.\n Please try again.';
const String kremembermeEn = "Remember me";
const String kforgetpasswordEn = "Forgot Password";
const String kemailEn = "Email";
const String kpasswordEn = "Password";
const String kconfirmpasswordEn = "Confirm Password";
const String kfirstnameEn = "First Name";
const String klastnameEn = "Last Name";
const String kphonenumberEn = "Phone Number";
const String kphonenumberhintEn = "Enter your phone number";
const String kaddressEn = "Address";
const String kaddresshintEn = "Enter your address";
const String kbirthdateEn = "date of birth";
const String ktypeEn = "Type";
const String kspecializationEn = "Speciality";
const String kspecializationhintEn = "Enter your speciality";
const String kdescriptionEn = "Description";
const String kemailhintEn = "Enter your email";
const String kpasswordhintEn = "Enter your password";
const String kconfirmpasswordhintEn = "Enter your confirm password";
const String kfirstnamehintEn = "Enter your first name";
const String klastnamehintEn = "Enter your last name";
const String knamehintEn = "Enter your name";
const String kregisterEn = "Register Account";
const String kcompletewithEn =
    "Complete your details or continue \nwith social media";
const String kconditionsEn =
    'By continuing your confirm that you agree \nwith our Term and Condition';
const String knameEn = "Name";
const String kpatientEn = 'Patient';
const String kproviderEn = 'Health care provider';
const String kcompletEn = "Complete Profile";
const String kbirthdatehintEn = "ex : 14-07-1988";
const String kAboutEn = "About";
const String kAbouthintEn = "I am a doctor";
const String khintEn = "Write about yourself";
const String kmaleEn = "Male";
const String kfemaleEn = "Female";
const String kSearchEn = "Search";
const String kOtpTitleEn="Co\nDE";
const String kOtpsubTitleEn="verification";
const String tOtpMessageEn="Enter the verifification code";
const String kForgetpasswordTitleEn="Make Selection";
const String kForgetPasswordSubTitleEn="Select one of the options given below to reset your password.";
const String kResetViaEmailEn="Reset via Mail Verification";
const String kResetViaPhoneEn="Reset via Phone Verification";
const String kForgetPhoneSubtitleEn="Enter your registred Phone Number to receive OTP";
const String kForgetEmailSubtitleEn="Enter your registred E-Mail Address to receive OTP";
const String kverificationEn="verification";
const String kemailverificationEn="Verify your email address";
const String kemailverificationSubtitleEn="We have just send email veriffication link on your email. Please check email and click on that link to verify your email address.\n\nif not auto redirected after verification,click on the Continue button.";
const String kresendemailLinkEn="Resend E-Mail Link";
const String tbackToLoginEn="back to login";
const String kchossepicEn= "Choose Profile photo";
const String kcameraEn ="Camera";
const String kselectimageEn='Select Image';
const String kbuildingpicEn="Choose building Picture";




//images
const String kProfile = "assets/images/avatar.jpg";
const String kDoctor = "assets/images/doctor.png";
const String kSplashScreen1 =
    "assets/images/Medical-app-development-costs-scaled-removebg-preview.png";
const String kSplashScreen2 =
    "assets/images/Offline-Mode-applications-removebg-preview.png";
const String kSplashScreen3 = "assets/images/splashscreen3.png";
const String kForgetPassImage="assets/images/pass.jpg";
const String kSuccess ="assets/images/succes.png";
