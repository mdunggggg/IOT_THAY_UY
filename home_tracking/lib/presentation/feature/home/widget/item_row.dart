import 'package:flutter/material.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';
import 'package:home_tracking/shared/extension/ext_widget.dart';
import 'package:home_tracking/shared/style_text/style_text.dart';

class ItemRow extends StatelessWidget {
  const ItemRow(
      {super.key, required this.title, required this.value, this.valueColor});

  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title).expanded(),
        8.width,
        Text(
          value,
          style: StyleApp.bold(
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
