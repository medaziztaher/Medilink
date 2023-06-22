import 'package:flutter/material.dart';
import 'package:medilink_client/utils/size_config.dart';
import 'package:medilink_client/widgets/chat/components/converstions.dart';

import 'followers.dart';

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Contacts : ",
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(20)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateScreenWidth(15),
              ),
              Container(
                  width: double.infinity,
                  height: getProportionateScreenWidth(120),
                  child: Followers()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Last Conversations : ",
                  style: TextStyle(fontSize: getProportionateScreenWidth(20)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: getProportionateScreenWidth(15),
          ),
          Expanded(
            child: Conversations(),
          ),
        ],
      ),
    );
  }
}
