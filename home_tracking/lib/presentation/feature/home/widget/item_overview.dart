import 'package:flutter/material.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';
import 'package:home_tracking/shared/style_text/style_text.dart';

class ItemOverview extends StatelessWidget {
  const ItemOverview(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle, required this.isUp});

  final Widget image;
  final String title;
  final String subTitle;
  final bool isUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        image,
        4.height,
        Text(
          title,
          style: StyleApp.medium(fontSize: 16, color: Color(0xFF0A3832)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              subTitle,
              style: StyleApp.medium(fontSize: 12, color: isUp ? Colors.green : Colors.red),
            ),
            isUp
                ? Icon(
                    Icons.trending_up,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.trending_down,
                    color: Colors.red,
                  ),
          ],
        ),
      ],
    );
  }
}
