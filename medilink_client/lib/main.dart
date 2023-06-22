import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/home/home_screen.dart';
import 'package:medilink_client/widgets/test.dart';
import 'api/user.dart';
import 'firebase/api/authentififcation.dart';
import 'firebase/api/notification.dart';
import 'firebase_options.dart';
import 'locale/locale.dart';
import 'locale/locale_controller.dart';
import 'settings/realtimelogic.dart';
import 'utils/constatnts.dart';
import 'utils/prefs.dart';
import 'utils/theme.dart';
import 'widgets/language_screen/language_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(Auth()));
  await FirebaseNotification().initNotification();
  final pref = Pref();
  await pref.initPrefs();
  //ConnectivityService();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SocketMethods _socket = SocketMethods();
  late Future<ConnectivityResult> _connectivityResult;

  @override
  void initState() {
    super.initState();
    _connectivityResult = checkInternet();
    _addConnectedUser();
    _socket.subscribeToEvents(context);
  }

  Future<ConnectivityResult> checkInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult.name);
    return connectivityResult;
  }

  void _addConnectedUser() async {
    final prefs = Pref();
    if (prefs.prefs!.getString(kTokenSave) != null) {
      pushDeviceToken();
      _socket.addUser();
    } else {
      return;
    }
  }

  void reloadMain() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runApp(const MyApp());
      setState(() {
        _connectivityResult = checkInternet();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
     final controller = Get.put(MyLocaleController());
    final hasToken = Pref().prefs!.getString(kTokenSave) != null;

    return FutureBuilder<ConnectivityResult>(
      future: _connectivityResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final connectivityResult = snapshot.data!;
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Medilink',
            locale: controller.initialLang,
            translations: MyLocale(),
            defaultTransition: Transition.leftToRightWithFade,
            transitionDuration: const Duration(milliseconds: 500),
            home: Builder(
              builder: (context) {
                if (connectivityResult == ConnectivityResult.none) {
                  return Scaffold(
                    body: Center(
                      child: AlertDialog(
                        title: Text('No Internet Connection'),
                        content: Text('Please check your internet connection.'),
                        actions: [
                          TextButton(
                            onPressed: () => reloadMain(),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (hasToken) {
                  return StreamBuilder<ConnectivityResult>(
                    stream: Connectivity().onConnectivityChanged,
                    builder: (context, snapshot) {
                      if (snapshot.data == ConnectivityResult.none) {
                        return Scaffold(
                          body: Center(
                            child: AlertDialog(
                              title: Text('No Internet Connection'),
                              content: Text(
                                  'Please check your internet connection.'),
                            ),
                          ),
                        );
                      } else {
                        return HomeScreen();
                      }
                    },
                  );
                } else {
                  return StreamBuilder<ConnectivityResult>(
                    stream: Connectivity().onConnectivityChanged,
                    builder: (context, snapshot) {
                      if (snapshot.data == ConnectivityResult.none) {
                        return Scaffold(
                          body: Center(
                            child: AlertDialog(
                              title: Text('No Internet Connection'),
                              content: Text(
                                  'Please check your internet connection.'),
                            ),
                          ),
                        );
                      } else {
                        return LanguageScreen();
                      }
                    },
                  );
                }
              },
            ),
            theme: theme(),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: AlertDialog(
                  title: Text('Error'),
                  content: Text(
                      'Error occurred while checking internet connection.\nPlease check your internet connection.'),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
