import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medilink_admin/utils/constatnts.dart';

import '../../../models/user.dart';
import '../../../services/networkhandler.dart';
import '../../../services/path.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  bool isLoading = false;
  NetworkHandler networkHandler = NetworkHandler();
  List<User> users = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> getusers() async {
    
    try {
      final response = await networkHandler.get(usersPath);
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final newUsers =
            data.map((item) => User.fromJson(item)).toList(growable: false);
        users = newUsers;
      }
    } catch (e) {
      print(e);
    } finally {
      
    }
  }

  Future<void> deleteUser(String userId) async {
    setState(() {
      isLoading = true;
    });
    try {
      await networkHandler.delete("$usersPath/$userId");
      getusers();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  Future<void> _initializeUser() async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      getusers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("List of Users"),
        if (isLoading)
          const CircularProgressIndicator()
        else
          ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.picture != null
                      ? CachedNetworkImageProvider(user.picture!)
                      : Image.asset(kProfile) as ImageProvider,
                ),
                title: Text(user.name!),
                subtitle: user.role == 'Patient'
                    ? Text(user.email!)
                    : Text(user.type ?? ""),
                trailing: ElevatedButton(
                  onPressed: () async {
                    deleteUser(user.id!);
                    getusers();
                  },
                  child: const Text("Delete"),
                ),
              );
            },
          )
      ],
    );
  }
}
