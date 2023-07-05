import 'package:get/get.dart';

import 'package:medilink_client/models/surgery.dart';

import '../../../api/user.dart';
import '../../../models/user.dart';
import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../../../utils/global.dart';

class GetSurgerieController extends GetxController {
  String surgerieId;
  RxString userId = "".obs;
  Surgerie surgerie = Surgerie();
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  RxString provider = "".obs;

  GetSurgerieController({required this.surgerieId}) {
    _init();
  }
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    String? userId = globalUserId;
    if (userId == null) {
      userId = await queryUserID();
    }
    this.userId.value = userId!;
    await getsurgerie();
    await getProvider();
  }

  Future<void> getProvider() async {
    try {
      final response =
          await networkHandler.get("$userData/${surgerie.provider}");
      if (response['status'] == true) {
        User user = User.fromJson(response['data']);
        provider.value = user.name!;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getsurgerie() async {
    try {
      final response = await networkHandler.get("$surgeriesPaths/$surgerieId");
      
      print(response['status']);
      if (response['status'] == true) {
        surgerie = Surgerie.fromJson(response['data']);
        update();
      }
    } catch (e) {
      print(e);
    }
  }
}
