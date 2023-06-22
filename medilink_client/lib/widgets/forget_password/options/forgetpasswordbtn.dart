import 'package:flutter/material.dart';



class ForgetPasswordbtn extends StatelessWidget {
  const ForgetPasswordbtn({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200),
        child: Row(
          children: [
            Icon(icon, size: 60),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextTheme(
                    titleLarge: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                  ).titleLarge,
                ),
                Text(subtitle)
              ],
            )
          ],
        ),
      ),
    );
  }
}
