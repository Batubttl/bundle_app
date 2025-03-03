import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/core/extensions/theme_extension.dart';
import 'package:bundle_app/core/theme/app_texts.dart';
import 'package:bundle_app/presentation/views/settings/theme_selection_view.dart';
import 'package:bundle_app/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _showImagesOnWifiOnly = false;
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar(
        title: AppStrings.settingsAppBar,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: context.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSettingItem(
                icon: Icons.notifications_outlined,
                iconColor: context.primaryColor,
                title: AppStrings.notificationsTitle,
                showArrow: true,
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.dark_mode_outlined,
                title: AppStrings.modeChangeText,
                showArrow: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThemeSelectionView(),
                    ),
                  );
                },
              ),
              _buildSettingItem(
                icon: Icons.language,
                title: AppStrings.scannerSettings,
                showArrow: true,
              ),
              _buildSettingItem(
                icon: Icons.apps_outlined,
                title: AppStrings.appIconText,
                showArrow: true,
              ),
              SizedBox(height: 32.h),
              Text(
                AppStrings.viewMode,
                style: AppTextStyles.caption.copyWith(
                  color: context.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  _buildViewModeOption(
                    title: AppStrings.gridViewText,
                    isSelected: _isGridView,
                    onTap: () => setState(() => _isGridView = true),
                  ),
                  SizedBox(width: 40.w),
                  _buildViewModeOption(
                    title: AppStrings.gridViewText,
                    isSelected: !_isGridView,
                    onTap: () => setState(() => _isGridView = false),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Text(
                AppStrings.appSettings,
                style: AppTextStyles.caption.copyWith(
                  color: context.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              _buildSwitchItem(
                title: AppStrings.wifiOption,
                value: _showImagesOnWifiOnly,
                onChanged: (value) =>
                    setState(() => _showImagesOnWifiOnly = value),
              ),
              _buildSettingItem(
                title: AppStrings.changeLanguage,
                showArrow: true,
              ),
              _buildSettingItem(
                title: AppStrings.changeCountry,
                showArrow: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    IconData? icon,
    Color? iconColor,
    required String title,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor ?? context.textColor, size: 24.sp),
              SizedBox(width: 16.w),
            ],
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: context.textColor,
                ),
              ),
            ),
            if (showArrow)
              Icon(Icons.arrow_forward_ios,
                  color: context.secondaryColor, size: 16.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildViewModeOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isSelected ? context.primaryColor : context.secondaryColor,
                width: 2,
              ),
              color: isSelected ? context.primaryColor : Colors.transparent,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: context.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: context.textColor,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: context.primaryColor,
          ),
        ],
      ),
    );
  }
}
