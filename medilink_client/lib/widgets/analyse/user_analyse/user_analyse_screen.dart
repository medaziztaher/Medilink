import 'package:flutter/material.dart';

import '../../../api/user.dart';
import '../../../models/user.dart';
import '../../../utils/global.dart';
import 'components/body.dart';

class UserAnalyseScreen extends StatefulWidget {
  const UserAnalyseScreen({super.key, required this.user});
  final User user;

  @override
  State<UserAnalyseScreen> createState() => _UserAnalyseScreenState();
}

class _UserAnalyseScreenState extends State<UserAnalyseScreen> {
  late Future<String?> _userIdFuture;

  @override
  void initState() {
    _userIdFuture = _initializeUser();
    super.initState();
  }

  Future<String?> _initializeUser() async {
    String? userId = globalUserId;
    if (userId == null) {
      userId = await queryUserID();
    }
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: FutureBuilder<String?>(
          future: _userIdFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              final userId = snapshot.data;
              if (userId == widget.user.id) {
                return Text("Analyses");
              } else {
                return Text("${widget.user.name} Analyses");
              }
            }
          },
        ),
      ),
      body: FutureBuilder<String?>(
        future: _userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final userId = snapshot.data;
            return Body(user: widget.user,userId:userId);
          }
        },
      ),
    );
  }
}
