import 'package:get/get.dart';

import 'package:medilink_client/models/diseases.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';

class UserDiseaseController extends GetxController {
  final RxList<Disease> diseases = <Disease>[].obs;
  String userId;
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  UserDiseaseController({required this.userId}) {
    _init();
  }
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await getUserDiseases();
  }

  Future<void> getUserDiseases() async {
    isLoading.value = true;
    try {
      final response =
          await networkHandler.get("${patientPath}/$userId/diseases");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final disease =
            data.map((item) => Disease.fromJson(item)).toList(growable: false);
        diseases.value = disease;
        //update();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
