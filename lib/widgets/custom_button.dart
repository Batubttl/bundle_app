import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String? imagePath;
  final IconData? icon;
  final bool hasMargin;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment? mainAxisAlignment;
  final double? imageSize;
  final double? iconSize;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.imagePath,
    this.icon,
    this.hasMargin = true,
    this.height = 54,
    this.borderRadius = 8,
    this.padding,
    this.mainAxisAlignment,
    this.imageSize = 24,
    this.iconSize = 24,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      margin: hasMargin ? const EdgeInsets.symmetric(horizontal: 24) : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: mainAxisAlignment ??
              (imagePath != null || icon != null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center),
          children: [
            if (imagePath != null) ...[
              Image.asset(
                imagePath!,
                height: imageSize,
                width: imageSize,
              ),
              const SizedBox(width: 12),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: iconSize,
                color: textColor,
              ),
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
