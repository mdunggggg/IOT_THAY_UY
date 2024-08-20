import 'package:flutter/material.dart';
import 'package:home_tracking/shared/style_text/style_text.dart';

class ItemOverview extends StatelessWidget {
  const ItemOverview(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle});

  final Image image;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        image,
        Text(
          title,
          style: StyleApp.medium(fontSize: 16, color: Color(0xFFDBDCE2)),
        ),
        Text(
          subTitle,
          style: StyleApp.medium(fontSize: 12, color: Color(0xFF0A3832)),
        ),
      ],
    );
  }
}
