
import 'package:flutter/material.dart';

import '../presentation/constants/colors.dart';
import '../presentation/constants/spacing.dart';
import '../presentation/constants/typography.dart';

Widget MainButton(
    {required String? title,
      required Function event,
      required bool largeButton,
      required Widget? icon}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          padding: EdgeInsets.symmetric(
              vertical: largeButton ? sp16 : sp8,
              horizontal: largeButton ? sp16 : sp12),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      onPressed: () {
        event();
      },
      // child: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     if (icon != null) icon,
      //     if (icon != null && title != null) const SizedBox(width: sp8),
      //     if (title != null && icon == null)
      //       Expanded(
      //         child: Text(
      //           title,
      //           textAlign: TextAlign.center,
      //           overflow: TextOverflow.ellipsis,
      //           style: largeButton ? h6 : p5,
      //         ),
      //       )
      //   ],
      // ),
      child: RichText(
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            if (icon != null)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: icon,
              ),
            if (icon != null)
              const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SizedBox(
                  width: sp8,
                ),
              ),
            if (title != null)
              TextSpan(
                text: title,
                style: largeButton ? h6 : p5,
              ),
          ],
        ),
      ));
}

Widget Extrabutton({
  required String? title,
  required Function event,
  required bool largeButton,
  required Color? borderColor,
  required Widget? icon,
  Color? bgColor,
  Color? color,
}) {
  return OutlinedButton(
      style: OutlinedButton.styleFrom(
          backgroundColor: bgColor ?? const Color.fromARGB(0, 0, 0, 0),
          padding: EdgeInsets.symmetric(
              vertical: largeButton ? sp16 : sp8,
              horizontal: largeButton ? sp16 : sp12),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(sp8)),
          side: BorderSide(color: borderColor ?? borderColor_2, width: 1)),
      onPressed: () {
        event();
      },
      // child: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     if (icon != null) icon,
      //     if (icon != null && title != null) const SizedBox(width: sp8),
      //     if (title != null)
      //       Expanded(
      //           child: Text(
      //         title,
      //         overflow: TextOverflow.ellipsis,
      //         textAlign: TextAlign.center,
      //         style: (largeButton ? h6 : p5).copyWith(color: color ?? blackColor),
      //       ))
      //   ],
      // ),
      child: RichText(
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            if (icon != null)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: icon,
              ),
            if (icon != null)
              const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SizedBox(
                  width: sp8,
                ),
              ),
            if (title != null)
              TextSpan(
                  text: title,
                  style: (largeButton ? h6 : p5)
                      .copyWith(color: color ?? blackColor)),
          ],
        ),
      ));
}

Widget SupportButton({
  required String? title,
  required Function event,
  required bool largeButton,
  required Widget? icon,
  required Color? backgroundColor,
  Color? color,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor ?? accentColor_5,
        padding: EdgeInsets.symmetric(
            vertical: largeButton ? sp16 : sp8,
            horizontal: largeButton ? sp16 : sp12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    onPressed: () {
      event();
    },
    child: RichText(
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          if (icon != null)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: icon,
            ),
          if (icon != null)
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: SizedBox(
                width: sp8,
              ),
            ),
          if (title != null)
            TextSpan(
              text: title,
              style: largeButton
                  ? h6.copyWith(color: color ?? blackColor)
                  : p5.copyWith(color: color ?? blackColor),
            ),
        ],
      ),
    ),
  );
}
