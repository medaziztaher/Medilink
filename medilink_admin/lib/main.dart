import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'apis/admin.dart';
import 'notifciation/notification.dart';
import 'services/realtimelogic.dart';
import 'utils/constatnts.dart';
import 'utils/prefs.dart';
import 'utils/theme.dart';
import 'widgets/authentification/signin/signin_screen.dart';
import 'widgets/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseNotification().initNotification();
  final pref = Pref();
  await pref.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    final hasToken = Pref().prefs!.getString(kTokenSave) != null;

    return FutureBuilder<ConnectivityResult>(
      future: _connectivityResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
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
            defaultTransition: Transition.leftToRightWithFade,
            transitionDuration: const Duration(milliseconds: 500),
            home: Builder(
              builder: (context) {
                if (connectivityResult == ConnectivityResult.none) {
                  return Scaffold(
                    body: Center(
                      child: AlertDialog(
                        title: const Text('No Internet Connection'),
                        content: const Text(
                            'Please check your internet connection.'),
                        actions: [
                          TextButton(
                            onPressed: () => reloadMain(),
                            child: const Text('OK'),
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
                        return const Scaffold(
                          body: Center(
                            child: AlertDialog(
                              title: Text('No Internet Connection'),
                              content: Text(
                                  'Please check your internet connection.'),
                            ),
                          ),
                        );
                      } else {
                        return HomeScreen(); //HomeScreen();
                      }
                    },
                  );
                } else {
                  return StreamBuilder<ConnectivityResult>(
                    stream: Connectivity().onConnectivityChanged,
                    builder: (context, snapshot) {
                      if (snapshot.data == ConnectivityResult.none) {
                        return const Scaffold(
                          body: Center(
                            child: AlertDialog(
                              title: Text('No Internet Connection'),
                              content: Text(
                                  'Please check your internet connection.'),
                            ),
                          ),
                        );
                      } else {
                        return const SignInScreen();
                      }
                    },
                  );
                }
              },
            ),
            theme: theme(),
          );
        } else {
          return const MaterialApp(
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