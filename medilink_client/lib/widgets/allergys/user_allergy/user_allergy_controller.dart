import 'package:get/get.dart';
import 'package:medilink_client/models/allergy.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';

class UserAllergeyController extends GetxController {
  final RxList<Allergy> allergies = <Allergy>[].obs;
  String userId;
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  UserAllergeyController({required this.userId}) {
    _init();
  }
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await getUserAllergy();
  }

  Future<void> getUserAllergy() async {
    isLoading.value = true;
    try {
      final response =
          await networkHandler.get("${patientPath}/$userId/allergies");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final allergy =
            data.map((item) => Allergy.fromJson(item)).toList(growable: false);
        allergies.value = allergy;
        //update();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
