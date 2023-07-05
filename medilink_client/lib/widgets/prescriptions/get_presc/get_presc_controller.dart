import 'package:get/get.dart';

import '../../../api/user.dart';
import '../../../models/prescription.dart';
import '../../../models/user.dart';
import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../../../utils/global.dart';

class GetPrescController extends GetxController {
  String prescId;
  RxString userId = "".obs;
  Prescription prescription = Prescription();
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  RxString provider = "".obs;

  GetPrescController({required this.prescId}) {
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
    await getPrescription();
    await getProvider();
  }

  Future<void> getProvider() async {
    try {
      final response =
          await networkHandler.get("$userData/${prescription.provider}");
      if (response['status'] == true) {
        User user = User.fromJson(response['data']);
        provider.value = user.name!;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPrescription() async {
    try {
      final response = await networkHandler.get("$prescriptionsPath/$prescId");
      print(response['status']);
      if (response['status'] == true) {
        prescription = Prescription.fromJson(response['data']);
        update();
      }
    } catch (e) {
      print(e);
    }
  }
}
