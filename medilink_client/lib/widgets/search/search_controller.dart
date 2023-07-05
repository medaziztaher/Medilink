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
      print("Server Response :${response.body}");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("Response Data: $responseData");

        final data = responseData['date'] as List<dynamic>;
        final user =
            data.map((item) => User.fromJson(item)).toList(growable: false);
        print("User List: $user");
        searchResults.value = user;
      } else {
        final responseData = json.decode(response.body);
        final message = responseData['message'];
        errorMessage.value = message;
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
