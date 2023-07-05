import 'package:get/get.dart';
import 'package:medilink_client/models/diseases.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';

class GetDiseaseController extends GetxController {
  String diseaseId;
  Disease disease = Disease();
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();

  GetDiseaseController({required this.diseaseId}) {
    _init();
  }
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await getDisease();
  }

  Future<void> getDisease() async {
    try {
      final response = await networkHandler.get("$disesePath/$diseaseId");
      if (response['status'] == true) {
        disease = Disease.fromJson(response['data']);
        update();
      }
    } catch (e) {
      print(e);
    }
  }
}
