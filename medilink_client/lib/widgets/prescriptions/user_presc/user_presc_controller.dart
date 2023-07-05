import 'package:get/get.dart';
import 'package:medilink_client/models/prescription.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';

class UserPrescController extends GetxController {
  final RxList<Prescription> prescriptions = <Prescription>[].obs;
  String userId;
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  UserPrescController({required this.userId}) {
    _init();
  }
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await getUserPrescriptions();
  }

  Future<void> getUserPrescriptions() async {
    isLoading.value = true;
    try {
      final response =
          await networkHandler.get("${patientPath}/$userId/prescriptions");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final prescription = data
            .map((item) => Prescription.fromJson(item))
            .toList(growable: false);
        prescriptions.value = prescription;
        //update();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
