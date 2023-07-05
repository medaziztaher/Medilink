import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../services/networkhandler.dart';
import '../../../services/path.dart';

class PendingProviders extends StatefulWidget {
  const PendingProviders({Key? key}) : super(key: key);

  @override
  State<PendingProviders> createState() => _PendingProvidersState();
}

class _PendingProvidersState extends State<PendingProviders> {
  bool isLoading = false;
  NetworkHandler networkHandler = NetworkHandler();
  List<User> users = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> pendingProvides() async {
    
    try {
      final response = await networkHandler.get(pendingHealthcareprovidersPath);
      if (response['status'] == true) {
        print(response);
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

  Future<void> approve(String userId) async {
    setState(() {
      isLoading = true;
    });
    final data = {
      'status': 'Approved',
    };

    try {
      await networkHandler.put("$healthcareprovidersPath/$userId", data);
      pendingProvides();
      setState(() {});
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
      pendingProvides();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("List of pending health care providers"),
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
                  backgroundImage: CachedNetworkImageProvider(user.picture!),
                ),
                title: Text(user.name!),
                subtitle: Text(user.verification ?? ""),
                trailing: ElevatedButton(
                  onPressed: () {
                    approve(user.id!);
                    pendingProvides();
                  },
                  child: const Text("Approve"),
                ),
              );
            },
          ),
      ],
    );
  }
}
