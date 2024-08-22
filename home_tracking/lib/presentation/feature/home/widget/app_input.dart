import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';

Widget AppInputSupport({
  String? initialValue,
  String? label,
  EdgeInsetsGeometry? padding,
  double? radius,
  required String hintText,
  TextEditingController? controller,
  TextInputType textInputType = TextInputType.text,
  Widget? suffixIcon,
  Widget? prefixIcon,
  String? Function(String? value)? validate,
  bool show = true,
  bool isPassword = false,
  int? maxLines,
  FocusNode? fn,
  bool required = false,
  Function? onTap,
  Color? borderColor,
  Color? backgroundColor,
  Function(String)? onChanged,
  Function(String)? onConfirm,
  Function()? onTapOutside,
  bool readOnly = false,
  TextAlign textAlign = TextAlign.start,
  TextStyle? labelStyle,
  List<TextInputFormatter>? inputFormatters,
  List<BoxShadow>? boxShadow,
  Key? key,
  bool? isDense,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (label != null)
        RichText(
          text: TextSpan(
            text: label,
            style: labelStyle ?? p5.copyWith(color: blackColor),
            children: [
              if (required)
                TextSpan(text: ' *', style: p5.copyWith(color: red_1))
            ],
          ),
        ),
      // Text('$label', style: p5),
      if (label != null) const SizedBox(height: sp8),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? sp8),
          boxShadow: boxShadow ??
              [
                const BoxShadow(
                  color: Colors.transparent,
                  blurRadius: sp2,
                  offset: Offset(0, 1),
                ),
              ],
        ),
        child: TextFormField(
          initialValue: initialValue,
          readOnly: readOnly,
          key: key,
          onTap: () {
            if (onTap != null) onTap();
          },
          onChanged: (String? value) {
            if (value != null && onChanged != null) {
              onChanged(value);
            }
          },
          onFieldSubmitted: (value) {
            if (onConfirm != null) {
              onConfirm(value);
            }
          },
          onTapOutside: (event) => onTapOutside?.call() ?? FocusManager.instance.primaryFocus?.unfocus(),
          maxLines: maxLines,
          keyboardType: textInputType,
          controller: controller,
          obscureText: !show,
          focusNode: fn,
          textAlign: textAlign,
          validator: validate,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            fillColor: backgroundColor,
            filled: backgroundColor != null,
            contentPadding: padding ?? const EdgeInsets.all(12),
            isDense: isDense,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? sp8),
              borderSide: BorderSide(
                color: borderColor ?? borderColor_2,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? sp8),
              borderSide: BorderSide(
                color: borderColor ?? borderColor_2,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? sp8),
              borderSide: BorderSide(
                color: borderColor ?? borderColor_2,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? sp8),
              borderSide: const BorderSide(
                color: mainColor,
                width: 1,
              ),
            ),
            hintText: hintText,
            hintStyle: p6.copyWith(color: greyColor),
            // label: Text(
            //   label,
            //   style: p5,
            // ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            // isPassword
            //   ? IconButton(
            //       icon: Icon(
            //         show ? Icons.visibility : Icons.visibility_off_outlined,
            //       ),
            //       onPressed: () {
            //         _loginController.changeShowPassword(value: show ? false.obs : true.obs);
            //       },
            //     )
            //   : Spacer(),
          ),
        ),
      ),
    ],
  );
}


Widget AppInput({
  String? initialValue,
  String? label,
  required String hintText,
  TextEditingController? controller,
  TextInputType textInputType = TextInputType.text,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Function(String? value)? validate,
  bool show = true,
  bool isPassword = false,
  int? maxLines,
  FocusNode? fn,
  bool required = false,
  Function? onTap,
  Color? borderColor,
  Color? backgroundColor,
  Function(String)? onChanged,
  Function(String)? onConfirm,
  Function()? onTapOutside,
  bool readOnly = false,
  TextAlign textAlign = TextAlign.start,
  TextStyle? labelStyle,
  List<TextInputFormatter>? inputFormatters,
  List<BoxShadow>? boxShadow,
  double? radius,
  final TextStyle? style,
  bool autofocus = false,
  // required Function onChanged
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // if (label != null)
      //   RichText(
      //     text: TextSpan(
      //       text: label,
      //       style: labelStyle ?? p5.copyWith(color: blackColor),
      //       children: [
      //         if (required)
      //           TextSpan(text: ' *', style: p5.copyWith(color: red_1))
      //       ],
      //     ),
      //   ),
      // // Text('$label', style: p5),
      // if (label != null) const SizedBox(height: sp8),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? sp8),
          boxShadow: boxShadow ??
              [
                BoxShadow(
                  color: Colors.grey.withOpacity(0), // Màu của shadow
                  // spreadRadius: sp4, // Bán kính lan truyền của shadow
                  blurRadius: sp2, // Độ mờ của shadow
                  offset: const Offset(0, 2), // Độ dịch chuyển của shadow
                ),
              ],
        ),
        child: TextFormField(
          initialValue: initialValue,
          readOnly: readOnly,
          style: style,
          onTap: () {
            if (onTap != null) onTap();
          },
          onChanged: (String? value) {
            if (value != null && onChanged != null) {
              onChanged(value);
            }
          },
          onFieldSubmitted: (value) {
            if (onConfirm != null) {
              onConfirm(value);
            }
          },
          autofocus: autofocus,
          onTapOutside: (event) => onTapOutside?.call(),
          maxLines: maxLines ?? 1,
          keyboardType: textInputType,
          controller: controller,
          obscureText: !show,
          focusNode: fn,
          textAlign: textAlign,
          validator: (value) {
            return validate?.call(value);
          },
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            label: Row(
              children: [
                Text(
                  label ?? '',
                  style: p5.copyWith(color: greyColor),
                  overflow: TextOverflow.ellipsis,
                ),
                Visibility(
                  visible: required,
                  child: Text(
                    ' *',
                    style: p5.copyWith(color: red_1),
                  ),
                ),
              ],
            ),
            fillColor: backgroundColor,
            filled: backgroundColor != null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: sp16,
              horizontal: sp16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor ?? borderColor_2,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor ?? borderColor_2,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: borderColor ?? borderColor_2,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: mainColor,
                width: 1,
              ),
            ),
            hintText: hintText,
            hintStyle: p6.copyWith(color: greyColor),
            // label: Text(
            //   label,
            //   style: p5,
            // ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            // isPassword
            //   ? IconButton(
            //       icon: Icon(
            //         show ? Icons.visibility : Icons.visibility_off_outlined,
            //       ),
            //       onPressed: () {
            //         _loginController.changeShowPassword(value: show ? false.obs : true.obs);
            //       },
            //     )
            //   : Spacer(),
          ),
        ),
      ),
    ],
  );
}
