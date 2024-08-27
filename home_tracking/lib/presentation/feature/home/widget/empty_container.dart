import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';

class EmptyContainer extends StatelessWidget {
  final String? msg;
  const EmptyContainer({super.key, this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp12),
      ),
      child: Column(
        children: [
          Lottie.asset(
            'assets/empty.json',
          ),
          const SizedBox(height: sp24),
          Text(
            msg ?? 'Danh sách rỗng',
            textAlign: TextAlign.center,
            style: p1.copyWith(color: greyColor),
          ),
        ],
      ),
    );
  }
}