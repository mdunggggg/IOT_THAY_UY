import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';

class CommonDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final Function(T?)? onChanged;
  final String hintText;
  final T? value;
  final Color? color;
  final Color? borderColor;
  final double? fontSize;
  final double iconSize;
  final String? label;
  final bool required;
  final bool showIconRemove;
  final bool isBorder;
  final String? Function(T?)? validate;
  final double radius;
  final Icon? icon;
  final TextStyle? style;

  const CommonDropdown({
    super.key,
    required this.items,
    this.onChanged,
    required this.hintText,
    this.value,
    this.color,
    this.fontSize,
    this.iconSize = 18,
    this.label,
    this.required = false,
    this.showIconRemove = true,
    this.isBorder = true,
    this.validate,
    this.borderColor,
    this.radius = sp8,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          RichText(
            text: TextSpan(
              text: label,
              style: p5.copyWith(color: blackColor),
              children: [
                if (required)
                  TextSpan(text: ' *', style: p5.copyWith(color: red_1)),
              ],
            ),
          ),
        if (label != null) const SizedBox(height: sp8),
        DropdownButtonFormField2(
          value: value,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(2),
            border: !isBorder
                ? InputBorder.none
                : OutlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? borderColor_2),
              borderRadius: BorderRadius.circular(radius),
            ),
            focusColor: blue_1,
            focusedBorder: !isBorder
                ? InputBorder.none
                : OutlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? accentColor_7),
              borderRadius: BorderRadius.circular(radius),
            ),
            enabledBorder: !isBorder
                ? InputBorder.none
                : OutlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? borderColor_2),
              borderRadius: BorderRadius.circular(radius),
            ),
            disabledBorder: !isBorder
                ? InputBorder.none
                : OutlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? borderColor_2),
              borderRadius: BorderRadius.circular(radius),
            ),
            // hintText: hintText,
          ),
          isExpanded: true,
          hint: Text(
            hintText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
          style: style,
          items: items,
          validator: (value) {
            if (required && value == null) {
              return 'Vui lòng chọn';
            }
            return null;
          },
          onChanged: onChanged,
          onSaved: (value) {},
          buttonStyleData: ButtonStyleData(
            height: 45,
            decoration: BoxDecoration(
              // border: Border.all(color: borderColor_2),
              borderRadius: BorderRadius.circular(radius),
              color: color,
            ),
            padding: const EdgeInsets.only(left: 0, right: 10),
          ),
          iconStyleData: IconStyleData(
            icon: Row(
              children: [
                if (value != null && showIconRemove)
                  IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: blackColor,
                      size: 15,
                    ),
                    onPressed: () {
                      onChanged?.call(null);
                    },
                  ),
                icon ??
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: blackColor,
                    ),
              ],
            ),
            iconSize: iconSize,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
      ],
    );
  }
}
