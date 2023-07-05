import 'package:get/get.dart';

import 'package:medilink_client/models/radiographie.dart';

import '../../../api/user.dart';
import '../../../models/user.dart';
import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../../../utils/global.dart';

class GetRadioController extends GetxController {
  String radioId;
  RxString userId = "".obs;
  Radiographie radiographie = Radiographie();
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  RxString provider = "".obs;

  GetRadioController({required this.radioId}) {
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
    await getradiographie();
    await getProvider();
  }

  Future<void> getProvider() async {
    try {
      final response =
          await networkHandler.get("$userData/${radiographie.provider}");
      if (response['status'] == true) {
        User user = User.fromJson(response['data']);
        provider.value = user.name!;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getradiographie() async {
    try {
      final response = await networkHandler.get("$radioPath/$radioId");
      print(response['status']);
      if (response['status'] == true) {
        radiographie = Radiographie.fromJson(response['data']);
        update();
      }
    } catch (e) {
      print(e);
    }
  }
}
