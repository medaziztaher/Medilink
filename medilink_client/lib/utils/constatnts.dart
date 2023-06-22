import 'package:flutter/material.dart';

import 'size_config.dart';

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
    borderSide: BorderSide(color: kTextColor),
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
const String kOtpTitleEn = "Co\nDE";
const String kOtpsubTitleEn = "verification";
const String tOtpMessageEn = "Enter the verifification code";
const String kForgetpasswordTitleEn = "Make Selection";
const String kForgetPasswordSubTitleEn =
    "Select one of the options given below to reset your password.";
const String kResetViaEmailEn = "Reset via Mail Verification";
const String kResetViaPhoneEn = "Reset via Phone Verification";
const String kForgetPhoneSubtitleEn =
    "Enter your registred Phone Number to receive OTP";
const String kForgetEmailSubtitleEn =
    "Enter your registred E-Mail Address to receive OTP";
const String kverificationEn = "verification";
const String kemailverificationEn = "Verify your email address";
const String kemailverificationSubtitleEn =
    "We have just send email veriffication link on your email. Please check email and click on that link to verify your email address.\n\nif not auto redirected after verification,click on the Continue button.";
const String kresendemailLinkEn = "Resend E-Mail Link";
const String tbackToLoginEn = "back to login";
const String kchossepicEn = "Choose Profile photo";
const String kcameraEn = "Camera";
const String kselectimageEn = 'Select Image';
const String kbuildingpicEn = "Choose building Picture";

//arabic
const String kEmailNullErrorAr = "يرجى إدخال البريد الإلكتروني";
const String kInvalidEmailErrorAr = "يرجى إدخال بريد إلكتروني صحيح";
const String kPassNullErrorAr = "يرجى إدخال كلمة المرور";
const String kShortPassErrorAr = "كلمة المرور قصيرة جدًا";
const String kconfirmPassNullErrorAr = 'يرجى إعادة إدخال كلمة المرور';
const String kMatchPassErrorAr = "كلمة المرور غير متطابقة";
const String kNamelNullErrorAr = "يرجى إدخال اسمك";
const String kFirstNamelNullErrorAr = "يرجى إدخال اسمك";
const String kLastNamelNullErrorAr = "يرجى إدخال اسم العائلة";
const String kTypeNullErrorAr = "يرجى إدخالا النوع";
const String kPhoneNumberNullErrorAr = "يرجى إدخال رقم هاتفك";
const String kAddressNullErrorAr = "يرجى إدخال عنوانك";
const String kRoleNullErrorAr = "يرجى إدخال دورك";
const String kGenderNullErrorAr = "يرجى إدخال جنسك";
const String kNamevalidationErrorAr = 'يرجى إدخال (حروف فقط)';
const String kPhoneNumberValidationAr = 'يرجى إدخال رقم هاتف صحيح';
const String kbirthdateValidationAr = 'يرجى إدخال تاريخ ميلاد صحيح';
const String kSpecializationNullErrorAr = "يرجى إدخال تخصص صحيح";
const String kdescriptionvalidationAr = "يرجى إدخال أقل من 3 أسطر";
const String kLanguageScreenAr = "اختر اللغة";
const String kEnglishAr = "الإنجليزية";
const String kFrenchAr = "الفرنسية";
const String kArabicAr = "العربية";
const String kbutton1Ar = "التالي";
const String ksplash1Ar = "مرحبًا بك";
const String ksplash2Ar = "نساعد الناس على التواصل مع أطبائهم";
const String ksplash3Ar = "نعرض كيفية مراقبة حالتك الصحية بسهولة";
const String ksigninAr = "تسجيل الدخول";
const String kwelcomeAr = "مرحبًا بعودتك";
const String kcontinueAr =
    "سجّل الدخول باستخدام بريدك الإلكتروني وكلمة المرور \nأو بوسائل التواصل الاجتماعي";
const String knoacountAr = "ليس لديك حساب!";
const String ksignupAr = "تسجيل";
const String kerror1Ar = 'غير قادر على الاتصال بالخادم\n. حاول مرة اخرى.';
const String kerror2Ar = "حدث خطأ غير متوقع.\nيرجى المحاولة مرة أخرى.";
const String kremembermeAr = "تذكرني";
const String kforgetpasswordAr = "نسيت كلمة المرور";
const String kemailAr = "البريد الإلكتروني";
const String kpasswordAr = "كلمة المرور";
const String kconfirmpasswordAr = "تأكيد كلمة المرور";
const String kfirstnameAr = "الاسم الأول";
const String klastnameAr = "اسم العائلة";
const String kphonenumberAr = "رقم الهاتف";
const String kaddressAr = "العنوان";
const String ktypeAr = "النوع";
const String kspecializationAr = "التخصص";
const String kdescriptionAr = "الوصف";
const String kemailhintAr = "أدخل بريدك الإلكتروني";
const String kpasswordhintAr = "أدخل كلمة المرور";
const String kconfirmpasswordhintAr = "أدخل كلمة المرور للتأكيد";
const String kfirstnamehintAr = "أدخل الاسم الأول";
const String klastnamehintAr = "أدخل اسم العائلة";
const String knamehintAr = "أدخل اسمك";
const String kregisterAr = "تسجيل حساب";
const String kcompletewithAr =
    "أكمل معلوماتك أو استمر \nمع وسائل التواصل الاجتماعي";
const String kconditionsAr =
    "من خلال المتابعة، فإنك تؤكد موافقتك \nعلى شروطنا وأحكامنا";
const String knameAr = "الاسم";
const String kpatientAr = "مريض";
const String kproviderAr = "مقدم الرعاية الصحية";
const String kcompletAr = "أكمل ملفك الشخصي";
const String kaddresshintAr = "أدخل عنوانك";
const String kphonenumberhintAr = "أدخل رقم هاتفك";
const String kbirthdateAr = "تاريخ الميلاد";
const String kbirthdatehintAr = "مثال: 14-07-1988";
const String kspecializationhintAr = "أدخل تخصصك";
const String khintAr = "اكتب عن نفسك";
const String kAbouthintAr = "أنا طبيب";
const String kAboutAr = "حول";
const String kfemaleAr = "أنثى";
const String kmaleAr = "ذكر";
const String kSearchAr = "بحث";
const String kOtpTitleAr = "كود";
const String kOtpsubTitleAr = "التحقق";
const String tOtpMessageAr = "أدخل رمز التحقق";
const String kForgetpasswordTitleAr = "اختر";
const String kForgetPasswordSubTitleAr =
    "اختر إحدى الخيارات التالية لإعادة تعيين كلمة المرور.";
const String kResetViaEmailAr = "إعادة تعيين عبر التحقق من البريد الإلكتروني";
const String kResetViaPhoneAr = "إعادة تعيين عبر التحقق من الهاتف";
const String kForgetPhoneSubtitleAr = "أدخل رقم هاتفك المسجل لتلقي رمز التحقق";
const String kForgetEmailSubtitleAr =
    "أدخل عنوان بريدك الإلكتروني المسجل لتلقي رمز التحقق";
const String kverificationAr = "التحقق";
const String kbuildingpicAr = "اختر صورة المبنى";
const String kemailverificationAr = "تحقق من عنوان بريدك الإلكتروني";
const String kemailverificationSubtitleAr =
    "لقد قمنا بإرسال رابط التحقق عبر البريد الإلكتروني إلى بريدك الإلكتروني. يُرجى التحقق من البريد الإلكتروني الخاص بك والنقر على الرابط للتحقق من عنوان بريدك الإلكتروني.\n\nإذا لم يتم إعادة توجيهك تلقائيًا بعد التحقق، انقر على زر المتابعة.";
const String kresendemailLinkAr = "إعادة إرسال رابط البريد الإلكتروني";
const String tbackToLoginAr = "العودة إلى تسجيل الدخول";

const String kchossepicAr = "اختر صورة الملف الشخصي";
const String kcameraAr = "الكاميرا";
const String kselectimageAr = "اختر صورة";

//frensh
const String kSearchFr = "Rechercher";
const String kEmailNullErrorFr = "Veuillez entrer votre adresse e-mail";
const String kInvalidEmailErrorFr = "Veuillez entrer une adresse e-mail valide";
const String kPassNullErrorFr = "Veuillez entrer votre mot de passe";
const String kShortPassErrorFr = "Le mot de passe est trop court";
const String kconfirmPassNullErrorFr =
    'Veuillez entrer à nouveau votre mot de passe';
const String kMatchPassErrorFr = "Les mots de passe ne correspondent pas";
const String kNamelNullErrorFr = "Veuillez entrer votre nom";
const String kFirstNamelNullErrorFr = "Veuillez entrer votre prénom";
const String kLastNamelNullErrorFr = "Veuillez entrer votre nom de famille";
const String kTypeNullErrorFr = "Veuillez entrer le champ de type";
const String kPhoneNumberNullErrorFr =
    "Veuillez entrer votre numéro de téléphone";
const String kAddressNullErrorFr = "Veuillez entrer votre adresse";
const String kRoleNullErrorFr = "Veuillez entrer votre rôle";
const String kGenderNullErrorFr = "Veuillez entrer votre genre";
const String kNamevalidationErrorFr =
    'Veuillez entrer un nom valide (lettres uniquement)';
const String kPhoneNumberValidationFr =
    'Veuillez entrer un numéro de téléphone valide';
const String kbirthdateValidationFr =
    'Veuillez entrer une date de naissance valide';
const String kSpecializationNullErrorFr =
    "Veuillez entrer une spécialisation valide";
const String kdescriptionvalidationFr = "Veuillez entrer moins de 3 lignes";
const String kLanguageScreenFr = "Choisissez la langue";
const String kEnglishFr = "Anglais";
const String kFrenchFr = "Français";
const String kArabicFr = "Arabe";
const String kbutton1Fr = "Suivant";
const String ksplash1Fr = "Bienvenue sur Medilink";
const String ksplash2Fr =
    "Nous aidons les gens à se connecter avec leurs médecins";
const String ksplash3Fr =
    "Nous montrons comment surveiller facilement \nvos conditions médicales";
const String ksigninFr = "Se connecter";
const String kwelcomeFr = "Content de vous revoir";
const String kcontinueFr =
    "Connectez-vous avec votre e-mail et votre mot de passe \nou continuez avec les réseaux sociaux";
const String knoacountFr = "Vous n'avez pas de compte !";
const String ksignupFr = "S'inscrire";
const String kerror1Fr =
    "Impossible de se connecter au serveur.\nVeuillez réessayer.";
const String kerror2Fr =
    "Une erreur inattendue s'est produite.\nVeuillez réessayer.";
const String kremembermeFr = "Se souvenir de moi";
const String kforgetpasswordFr = "Mot de passe oublié";
const String kemailFr = "Email";
const String kpasswordFr = "Mot de passe";
const String kconfirmpasswordFr = "Confirmer le mot de passe";
const String kfirstnameFr = "Prénom";
const String klastnameFr = "Nom de famille";
const String kphonenumberFr = "Numéro de téléphone";
const String kaddressFr = "Adresse";
const String ktypeFr = "Type";
const String kspecializationFr = "Spécialité";
const String kdescriptionFr = "Description";
const String kemailhintFr = "Entrez votre adresse e-mail";
const String kpasswordhintFr = "Entrez votre mot de passe";
const String kconfirmpasswordhintFr =
    "Entrez votre mot de passe de confirmation";
const String kfirstnamehintFr = "Entrez votre prénom";
const String klastnamehintFr = "Entrez votre nom de famille";
const String knamehintFr = "Entrez votre nom";
const String kregisterFr = "Créer un compte";
const String kcompletewithFr =
    "Complétez vos informations ou continuez \navec les réseaux sociaux";
const String kconditionsFr =
    "En continuant,\n vous confirmez que vous acceptez \nnos conditions générales d'utilisation";
const String knameFr = "Nom";
const String kpatientFr = "Patient";
const String kproviderFr = "Fournisseur de soin";
const String kcompletFr = "complétez votre profil";
const String kaddresshintFr = "Entrez votre adresse";
const String kphonenumberhintFr = "Entrez votre numéro de téléphone";
const String kbirthdateFr = "Date de naissance";
const String kbirthdatehintFr = "ex : 14-07-1988";
const String kspecializationhintFr = "Entrez votre spécialité";
const String kAboutFr = "À propos";
const String khintFr = "écrire sur vous";
const String kAbouthintFr = "Je suis médecin";
const String kmaleFr = "Homme";
const String kfemaleFr = "Femme";
const String kOtpTitleFr = "Code";
const String kOtpsubTitleFr = "Vérification";
const String tOtpMessageFr = "Entrez le code de vérification ";
const String kForgetpasswordTitleFr = "Faire une sélection";
const String kForgetPasswordSubTitleFr =
    "Sélectionnez l'une des options ci-dessous pour réinitialiser votre mot de passe.";
const String kResetViaEmailFr = "Réinitialiser via la vérification par e-mail";
const String kResetViaPhoneFr =
    "Réinitialiser via la vérification par téléphone";
const String kForgetPhoneSubtitleFr =
    "Entrez votre numéro de téléphone enregistré pour recevoir le code de vérification";
const String kForgetEmailSubtitleFr =
    "Entrez votre adresse e-mail enregistrée pour recevoir le code de vérification";
const String kverificationFr = "vérification";
const String kemailverificationFr = "Vérifiez votre adresse e-mail";
const String kemailverificationSubtitleFr =
    "Nous venons d'envoyer un lien de vérification par e-mail à votre adresse e-mail. Veuillez vérifier votre e-mail et cliquer sur ce lien pour vérifier votre adresse e-mail.\n\nSi vous n'êtes pas redirigé automatiquement après la vérification, cliquez sur le bouton Continuer.";
const String kresendemailLinkFr = "Renvoyer le lien par e-mail";
const String tbackToLoginFr = "Retour à la page de connexion";
const String kchossepicFr = "Choisissez une photo de profil";
const String kcameraFr = "Appareil photo";
const String kselectimageFr = "Sélectionner une image";
const String kbuildingpicFr = "Choisir une image du bâtiment";
//images
const String kProfile = "assets/images/avatar.jpg";
const String kDoctor = "assets/images/doctor.png";
const String kSplashScreen1 =
    "assets/images/Medical-app-development-costs-scaled-removebg-preview.png";
const String kSplashScreen2 =
    "assets/images/Offline-Mode-applications-removebg-preview.png";
const String kSplashScreen3 = "assets/images/splashscreen3.png";
const String kForgetPassImage = "assets/images/pass.png";
const String kSuccess = "assets/images/succes.png";
const String kAccessdenied = "assets/images/accessdenied.jpg";
