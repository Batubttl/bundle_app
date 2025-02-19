import 'package:bundle_app/core/extensions/theme_extension.dart';
import 'package:bundle_app/core/theme/app_colors.dart';
import 'package:bundle_app/core/theme/app_texts.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
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
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.imagePath,
    this.icon,
    this.hasMargin = true,
    this.height = 54,
    this.borderRadius = 8,
    this.padding,
    this.mainAxisAlignment,
    this.imageSize = 24,
    this.iconSize = 24,
    this.fontSize,
    this.fontWeight,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      margin: hasMargin ? EdgeInsets.symmetric(horizontal: 24) : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? context.primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: textColor ?? AppColors.white,
                ),
              )
            : Row(
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
                      color: textColor ?? AppColors.white,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.button.copyWith(
                      color: textColor ?? AppColors.white,
                      fontSize: fontSize,
                      fontWeight: fontWeight ?? FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
