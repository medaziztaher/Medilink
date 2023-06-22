import 'dart:convert';

import 'package:get/get.dart';

import '../../models/user.dart';
import '../../settings/networkhandler.dart';
import '../../settings/path.dart';
import '../../utils/prefs.dart';

class SearchController extends GetxController {
  final prefs = Pref();

  NetworkHandler networkHandler = NetworkHandler();
  final Rx<String> _username = Rx<String>('');
  String get username => _username.value;
  set username(String value) => _username.value = value;
  RxList<User> searchResults = RxList<User>([]);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    ever(_username, (_) => searchUsers());
  }

  void clearSearchResults() {
    searchResults.clear();
  }
 Future<void> searchUsers() async {
  isLoading.value = true;
  errorMessage.value = '';

  Map<String, dynamic> requestData = {
    'search': username,
  };

  try {
    final response = await networkHandler.post(searchpath, requestData);
    if (response.statusCode == 200) {
      print(response.statusCode);
      if (response.body != null) {
        List<dynamic> responseData = json.decode(response.body);
        if (responseData != null && responseData is List) {
          List<User> users = responseData.map((item) => User.fromJson(item)).toList();
          searchResults.assignAll(users);
        } else {
          errorMessage.value = 'Invalid response data';
        }
      } else {
        errorMessage.value = 'No user found';
      }
      username = '';
    } else if (response.statusCode == 201) {
      errorMessage.value = 'No user found';
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    errorMessage.value = 'Error: ${e.toString()}';
  } finally {
    isLoading.value = false;
  }
}
}