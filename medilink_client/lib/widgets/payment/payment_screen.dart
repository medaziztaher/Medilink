import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/api/user.dart';
import 'package:medilink_client/utils/constatnts.dart';
import 'package:medilink_client/utils/global.dart';
import 'package:medilink_client/utils/size_config.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../settings/path.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {super.key,
      required this.providerId,
      required this.appointmentId,
      required this.patientId});
  final String providerId;
  final String appointmentId;
  final String patientId;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final WebViewController controller;
  var loadingPercentage = 0;
  late final String? patientId;

  @override
  void initState() {
    try {
      late final PlatformWebViewControllerCreationParams params;

      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }
      controller = WebViewController.fromPlatformCreationParams(params);

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
              setState(() {
                loadingPercentage = progress;
              });
            },
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
              setState(() {
                loadingPercentage = 0;
              });
            },
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url');
              setState(() {
                loadingPercentage = 100;
              });

              if (url.toLowerCase().contains("success")) {}
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                debugPrint('blocking navigation to ${request.url}');
                return NavigationDecision.prevent;
              }
              debugPrint('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            },
          ),
        );
      paymentAppointment();
    } catch (e) {
      debugPrint("$e");
    }
    super.initState();
  }

  Future<void> paymentAppointment() async {
    Map<String, dynamic> requestData = {
      'doctorId': widget.providerId,
      'patientId': widget.patientId,
      'appointmentId': widget.appointmentId
    };
    try {
      String url = "https://try-tryagain.com";
      var response = await networkHandler.post(paymentPath, requestData);
      print("Response : ${response.body}");
      if (response.statusCode == 200) {
        final paymentData = json.decode(response.body);
        url = paymentData["payUrl"];
      } else {
        final result = json.encode(response.body);
        Get.snackbar("Sorry", result);
        Get.back();
      }
      setState(() {
        controller.loadRequest(Uri.parse(url));
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.data == ConnectivityResult.none) {
            return Scaffold(
              body: Center(
                child: AlertDialog(
                  title: Text('No Internet Connection'),
                  content: Text('Please check your internet connection.'),
                ),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: const Text('Payment'),
                    actions: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Center(
                              child: Text(
                            "Go Home",
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor),
                          )),
                        ),
                      )
                    ]),
                body: WillPopScope(
                  onWillPop: () async {
                    try {
                      if (await controller.canGoBack()) {
                        controller.goBack();
                        return false;
                      } else {
                        return true;
                      }
                    } on Exception {
                      Get.snackbar("Sorry", "please try again");
                      return true;
                    }
                  },
                  child: Stack(
                    children: [
                      WebViewWidget(
                        controller: controller,
                      ),
                      if (loadingPercentage < 100)
                        LinearProgressIndicator(
                          value: loadingPercentage / 100.0,
                          color: Colors.redAccent,
                          backgroundColor: Colors.grey,
                        ),
                    ],
                  ),
                ));
          }
        });
  }
}
