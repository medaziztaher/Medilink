import 'package:get/get.dart';

import '../../../models/surgery.dart';
import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';

class UserSurgerieController extends GetxController {
  final RxList<Surgerie> surgeries = <Surgerie>[].obs;
  String userId;
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  UserSurgerieController({required this.userId}) {
    _init();
  }
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await getUserSurgerie();
  }

  Future<void> getUserSurgerie() async {
    isLoading.value = true;
    try {
      final response =
          await networkHandler.get("${patientPath}/$userId/surgeries");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final surgerie =
            data.map((item) => Surgerie.fromJson(item)).toList(growable: false);
        surgeries.value = surgerie;
        //update();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
