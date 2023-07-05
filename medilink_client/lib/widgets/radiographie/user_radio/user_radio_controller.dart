import 'package:get/get.dart';

import 'package:medilink_client/models/radiographie.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';

class UserRadioController extends GetxController {
  final RxList<Radiographie> radiographies = <Radiographie>[].obs;
  String userId;
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  UserRadioController({required this.userId}) {
    _init();
  }
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await getUserRadiographie();
  }

  Future<void> getUserRadiographie() async {
    isLoading.value = true;
    try {
      final response =
          await networkHandler.get("${patientPath}/$userId/radiographies");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final radio = data
            .map((item) => Radiographie.fromJson(item))
            .toList(growable: false);
        radiographies.value = radio;
        //update();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
