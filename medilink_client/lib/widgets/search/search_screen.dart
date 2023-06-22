import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/bottom_navbar.dart';
import '../../models/user.dart';
import '../../utils/enum.dart';
import '../user/user_screen.dart';
import 'search_controller.dart';

class SearchScreen extends StatelessWidget {
  final SearchController _searchController = Get.put(SearchController());

  void navigateToUserCard(String userId) {
    Get.to(UserScreen(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('kSearch'.tr),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: Key('search_text_field'),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _searchController.username = value;
              },
            ),
          ),
          GetX<SearchController>(
            builder: (_) {
              if (_.isLoading.value) {
                return const CircularProgressIndicator();
              } else if (_.errorMessage.value.isNotEmpty) {
                return Text(_.errorMessage.value);
              } else if (_.searchResults.isEmpty) {
                return const Text('No results found.');
              } else {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _.searchResults.length,
                    itemBuilder: (context, index) {
                      User user = _.searchResults[index];
                      return GestureDetector(
                        onTap: () {
                          _searchController.clearSearchResults();
                          navigateToUserCard(user.id!);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(user.picture!),
                          ),
                          title: Text(user.name!),
                         subtitle: user.role == 'Patient'
                              ? Text(user.email!)
                              : Text('${user.type}'),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          /*GetX<SearchController>(
            builder: (_) => _.errorMessage.value.isNotEmpty
                ? Text(
                    _.errorMessage.value,
                    style: TextStyle(color: Colors.red),
                  )
                : SizedBox.shrink(),
          ),*/
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.search),
    );
  }
}
