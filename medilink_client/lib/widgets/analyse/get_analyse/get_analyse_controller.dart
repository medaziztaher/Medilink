import 'package:get/get.dart';

import 'package:medilink_client/models/labresult.dart';

import '../../../api/user.dart';
import '../../../models/user.dart';
import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../../../utils/global.dart';

class GetAnalyseController extends GetxController {
  String analyseId;
  RxString userId = "".obs;
  Labresult analyse = Labresult();
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  RxString provider = "".obs;

  GetAnalyseController({required this.analyseId}) {
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
    await getAnalyse();
    await getProvider();
  }

  Future<void> getProvider() async {
    try {
      final response =
          await networkHandler.get("$userData/${analyse.provider}");
      if (response['status'] == true) {
        User user = User.fromJson(response['data']);
        provider.value = user.name!;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAnalyse() async {
    try {
      final response = await networkHandler.get("$labresultPath/$analyseId");
      print(response['status']);
      if (response['status'] == true) {
        analyse = Labresult.fromJson(response['data']);
        update();
      }
    } catch (e) {
      print(e);
    }
  }
}
