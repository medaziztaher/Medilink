import 'package:get/get.dart';
import 'package:medilink_client/models/labresult.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';

class UserAnalysesController extends GetxController {
  final RxList<Labresult> analyses = <Labresult>[].obs;
  String userId;
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  UserAnalysesController({required this.userId}) {
    _init();
  }
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await getUserAnalyse();
  }

  Future<void> getUserAnalyse() async {
    isLoading.value = true;
    try {
      final response =
          await networkHandler.get("${patientPath}/$userId/labresult");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final analyse =
            data.map((item) => Labresult.fromJson(item)).toList(growable: false);
        analyses.value = analyse;
        //update();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
