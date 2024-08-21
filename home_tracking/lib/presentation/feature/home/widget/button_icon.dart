import 'package:flutter/material.dart';
class ButtonIcon extends StatefulWidget {
  const ButtonIcon({super.key, required this.type});

  final TypeDevice type;

  @override
  State<ButtonIcon> createState() => _ButtonIconState();
}

class _ButtonIconState extends State<ButtonIcon> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

enum TypeDevice{
  light,
  fan,
  airConditioner,
}
