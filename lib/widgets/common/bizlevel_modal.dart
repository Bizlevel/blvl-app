import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';

class BizLevelModal extends StatelessWidget {
  const BizLevelModal({
    super.key,
    required this.title,
    this.subtitle,
    required this.primaryLabel,
    required this.onPrimary,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(icon, color: AppColor.primary),
            ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      content: subtitle == null ? null : Text(subtitle!),
      actions: [
        BizLevelButton(
          label: primaryLabel,
          onPressed: () {
            Navigator.of(context).pop();
            onPrimary();
          },
        ),
      ],
    );
  }
}
