import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final VoidCallback onPressed;

  const SocialButton({
    Key? key,
    this.icon,
    this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        color: Colors.white,
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
