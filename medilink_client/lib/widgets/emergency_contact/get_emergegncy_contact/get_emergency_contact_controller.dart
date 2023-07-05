import 'package:get/get.dart';



import '../../../models/emergency_contact.dart';
import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';

class UserEmergencyContactController extends GetxController {
  final RxList<EmergencyContact> emergencyContacts = <EmergencyContact>[].obs;
  String userId;
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  UserEmergencyContactController({required this.userId}) {
    _init();
  }
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await getUserEmergencyContacts();
  }

  Future<void> getUserEmergencyContacts() async {
    isLoading.value = true;
    try {
      final response =
          await networkHandler.get("$patientPath/$userId/emergency-contacts");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final emergencyContact =
            data.map((item) => EmergencyContact.fromJson(item)).toList(growable: false);
        emergencyContacts.value = emergencyContact;
        //update();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
