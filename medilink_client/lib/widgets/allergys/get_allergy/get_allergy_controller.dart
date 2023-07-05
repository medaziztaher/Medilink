import 'package:get/get.dart';
import 'package:medilink_client/models/allergy.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';

class GetAllergyController extends GetxController {
  String allergyId;
  Allergy allergy=Allergy();
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();

  
  GetAllergyController({required this.allergyId}) {
    _init();
  }
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await getAllergy();
  }

  Future<void> getAllergy() async {
    try {
      final response = await networkHandler.get("$allergysPath/$allergyId");
      print(response['status']);
      if (response['status'] == true) {
        allergy = Allergy.fromJson(response['data']);
        update();
      }
    } catch (e) {
      print(e);
    }
  }
}
