import 'package:flutter/material.dart';

import '../models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  const UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height/3,
          color: Colors.red,
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("title"),
                Text("title"),
                Text("title"),
              ],
            ),
            IconButton(onPressed: (){}, icon: Icon(Icons.favorite_outline)),

          ],
        ),)
      
      
      ]),
    );
  }
}