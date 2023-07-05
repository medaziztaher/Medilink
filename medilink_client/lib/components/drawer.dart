import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:medilink_client/utils/constatnts.dart';
import 'package:medilink_client/utils/size_config.dart';
import 'package:medilink_client/widgets/profil/profile_screen.dart';
import 'package:medilink_client/widgets/signin/signin_screen.dart';

import '../firebase/api/authentififcation.dart';
import '../models/user.dart';
import '../utils/prefs.dart';
import '../widgets/allergys/add_allergy/add_allergy_screen.dart';
import '../widgets/analyse/add_analyse/add_analyse_screen.dart';
import '../widgets/diseases/add_disease/add_disease_screen.dart';
import '../widgets/dossier_medicale/dossier_screen.dart';

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
              SizedBox(height: getProportionateScreenWidth(20)),
              if (user.role == "Patient") ...[
                ListTile(
                  title: const Text("Dossier Medicale"),
                  trailing: const Icon(Icons.folder),
                  onTap: () => Get.to(() => DossierMedicale(user: user)),
                ),
              ],
              ListTile(
                title: const Text("Edit Profil"),
                trailing: const Icon(Icons.person_2_outlined),
                onTap: () async {
                  Get.off(() => ProfileScreen(user:user));
                },
              ),
              ListTile(
                title: const Text("Logout"),
                trailing: const Icon(Icons.power_settings_new),
                onTap: () async {
                  await auth.logout();
                  await pref.prefs?.clear();
                  Get.offAll(() => SignInScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
