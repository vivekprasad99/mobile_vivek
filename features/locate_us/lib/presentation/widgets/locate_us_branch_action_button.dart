import 'package:core/config/resources/app_colors.dart';
import 'package:flutter/material.dart';

class BranchActionButton extends StatelessWidget {
  const BranchActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 16,
      ),
      label: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.secondaryLight,
            ),
      ),
    );
  }
}
