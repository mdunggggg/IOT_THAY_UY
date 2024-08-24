import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.isLoading});

  final bool value;
  final Function(bool) onChanged;
  final bool isLoading;

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.value,
      onChanged: (value) {
        if (!widget.isLoading) {
          widget.onChanged(value);
        }
      },
      activeColor:
          !widget.isLoading ? const Color(0xFF28776E) : Color(0xFFBDAFAF),
      activeTrackColor:
          !widget.isLoading ? const Color(0xFF4CA89D) : Colors.grey,
      inactiveTrackColor:
          !widget.isLoading ? const Color(0xFFFFFFFF) : Colors.grey,
      inactiveThumbColor:
          !widget.isLoading ? const Color(0xFF0B0000) : Color(0xFFBDAFAF),
    );
  }
}
