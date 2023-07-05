import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/default_button.dart';
import '../../../locale/locale.dart';
import '../../../locale/locale_controller.dart';
import '../../../utils/size_config.dart';
import '../../intro/intro_screen.dart';

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    final MyLocaleController controller = Get.find();
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  String? language;
                  String languageCode = Get.locale!.languageCode;
                  if (languageCode == 'en') {
                    if (index == 0) {
                      language = MyLocale().keys[languageCode]!['kEnglish'];
                    } else if (index == 1) {
                      language = MyLocale().keys[languageCode]!['kFrench'];
                    } else if (index == 2) {
                      language = MyLocale().keys[languageCode]!['kArabic'];
                    }
                  } else if (languageCode == 'fr') {
                    if (index == 0) {
                      language = MyLocale().keys[languageCode]!['kEnglish'];
                    } else if (index == 1) {
                      language = MyLocale().keys[languageCode]!['kFrench'];
                    } else if (index == 2) {
                      language = MyLocale().keys[languageCode]!['kArabic'];
                    }
                  } else {
                    if (index == 0) {
                      language = MyLocale().keys[languageCode]!['kEnglish'];
                    } else if (index == 1) {
                      language = MyLocale().keys[languageCode]!['kFrench'];
                    } else if (index == 2) {
                      language = MyLocale().keys[languageCode]!['kArabic'];
                    }
                  }
                  return GestureDetector(
                    onTap: () {
                      if (language ==
                          MyLocale().keys[languageCode]!['kEnglish']) {
                        controller.changeLang('en');
                      } else if (language ==
                          MyLocale().keys[languageCode]!['kFrench']) {
                        controller.changeLang('fr');
                      } else {
                        controller.changeLang('ar');
                      }
                    },
                    child: ListTile(
                      title: Text(language!),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DefaultButton(
                text: "kbutton1".tr,
                press: () {
                  Get.to(() => const SplashScreen());
                },
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.03),
          ],
        ),
      ),
    );
  }
}
