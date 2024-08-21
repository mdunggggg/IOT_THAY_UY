import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key, required this.value, required this.onChanged});

  final bool value;
  final Function(bool) onChanged;

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.value,
      onChanged: widget.onChanged,
      activeColor: const Color(0xFF28776E),
      activeTrackColor: const Color(0xFF4CA89D),
    );
  }
}
