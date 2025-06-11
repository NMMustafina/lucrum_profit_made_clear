import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'color_asf.dart';
import 'new_buti.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
     this.icon,
    this.onTap,
    this.padding,
    this.textColor = Colors.white,
    this.colorAll = true,
  });

  final String text;
  final String? icon;
  final Function()? onTap;
    final EdgeInsets? padding;
  final Color? textColor;
  final bool? colorAll;

  @override
  Widget build(BuildContext context) {
    return NewMotiBut(
      onPressed: onTap,
      child: IntrinsicHeight(
        child: Container(
          margin: padding,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: colorAll ==false? ColorAsf.g575F67 :null,
            gradient: colorAll == true
                ? const LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
             icon == null ? SizedBox(): SvgPicture.asset(icon!),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool?> showLeaveConfirmationDialog(BuildContext context) {
  return showCupertinoDialog<bool>(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text(
          'Leave the screen?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'If you leave, any changes you have\nmade will not be saved',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            isDefaultAction: true,
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: ColorAsf.blueNew,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            isDestructiveAction: true,
            child: const Text(
              'Leave',
              style: TextStyle(
                color: ColorAsf.blueNew,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    },
  );
}
