import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medilink_client/api/user.dart';
import 'package:medilink_client/utils/constatnts.dart';
import 'package:medilink_client/utils/size_config.dart';
import 'package:medilink_client/widgets/allergys/allergy.dart';
import 'package:medilink_client/widgets/diseases/diseases_screen.dart';

import '../firebase/api/authentififcation.dart';
import '../models/user.dart';
import '../utils/prefs.dart';
import '../widgets/labresult/labresult_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    final pref = Pref();
    final auth = Auth.instance;

    SizeConfig().init(context);
    return SizedBox(
      width: getProportionateScreenWidth(300),
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: user.picture != null
                                ? CachedNetworkImageProvider(user.picture!)
                                : const AssetImage(kProfile) as ImageProvider,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(user.name ?? ""),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(user.email ?? ""),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              /*ListTile(
                title: const Text("Settings"),
                trailing: const Icon(Icons.settings),
                onTap: () {},
              ),*/
              Spacer(),
              if (user.role == "Patient")
                ListTile(
                    title: const Text("Add Analyse"),
                    trailing: const Icon(Icons.file_open),
                    onTap: () =>
                        Get.to(() => LabresultScreen(userId: user.id!))),
              if (user.role == "Patient")
                ListTile(
                  title: const Text("Add Disease"),
                  trailing: const Icon(Icons.file_open),
                  onTap: () => Get.to(() => DiseasesScreen(userId: user.id!)),
                ),
              if (user.role == "Patient")
                ListTile(
                  title: const Text("Add Allergy"),
                  trailing: const Icon(Icons.file_open),
                  onTap: () => Get.to(() => AllergysScreen(userId: user.id!)),
                ),
              ListTile(
                title: const Text("Feedback"),
                trailing: const Icon(Icons.feedback),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Logout"),
                trailing: const Icon(Icons.power_settings_new),
                onTap: () async {
                  await auth.logout();
                  await pref.prefs?.clear();
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
