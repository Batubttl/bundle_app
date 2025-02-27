import 'package:bundle_app/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    this.icon,
    this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.secondaryColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        color: context.whiteColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: imagePath != null
                ? Image.asset(
                    imagePath!,
                    width: 36,
                    height: 36,
                  )
                : Icon(
                    icon ?? Icons.error,
                    color: Colors.black,
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }
}
