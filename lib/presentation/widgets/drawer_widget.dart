import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/presentation/views/auth/welcome_view.dart';
import 'package:bundle_app/presentation/views/drawer/currency_detail_view.dart';
import 'package:bundle_app/presentation/views/drawer/weather_detail_view.dart';
import 'package:bundle_app/presentation/views/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/extensions/theme_extension.dart';
import '../../core/theme/app_texts.dart';
import '../../core/theme/app_colors.dart';
import '../../services/weather_service.dart';
import '../../services/currency_service.dart';
import 'package:get_it/get_it.dart';

class DrawerWidget extends StatefulWidget {
  final bool isDrawerButton;

  const DrawerWidget({
    super.key,
    this.isDrawerButton = false,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final WeatherService _weatherService = GetIt.I<WeatherService>();
  final CurrencyService _currencyService = GetIt.I<CurrencyService>();
  String temperature = '--°';
  String usdRate = '--';

  @override
  void initState() {
    super.initState();
    _getWeather();
    _getCurrencyRates();
  }

  Future<void> _getWeather() async {
    try {
      final weatherData = await _weatherService.getWeatherDetails();
      setState(() {
        temperature = weatherData.temperature;
      });
    } catch (e) {
      debugPrint('Hava durumu alınamadı: $e');
    }
  }

  Future<void> _getCurrencyRates() async {
    try {
      final currencyData = await _currencyService.getCurrencyRates();
      setState(() {
        usdRate = currencyData.usdToTry.toStringAsFixed(3);
      });
    } catch (e) {
      debugPrint('Döviz kuru alınamadı: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDrawerButton) {
      return Builder(
        builder: (BuildContext context) => IconButton(
          icon: Icon(Icons.menu,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.white
                  : AppColors.black,
              size: 24.sp),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      );
    }

    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        color: context.backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: context.primaryColor,
                          radius: 20.r,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WelcomeView(),
                                ),
                              );
                            },
                            icon: Icon(Icons.arrow_forward,
                                color: AppColors.white),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          AppStrings.loginButtonText,
                          style: AppTextStyles.body.copyWith(
                            color: context.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.settings,
                          color: context.textColor, size: 24.sp),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsView(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CurrencyDetailView(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 4.w),
                          Text(
                            '$usdRate   USD',
                            style: AppTextStyles.body.copyWith(
                              color: context.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeatherDetailView(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.cloud,
                              color: context.textColor, size: 20.sp),
                          SizedBox(width: 4.w),
                          Text(
                            '$temperature ${AppStrings.cityName}',
                            style: AppTextStyles.caption.copyWith(
                              color: context.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Column(
                  children: [
                    Column(
                      children: [
                        _buildCategoryButton(context, AppStrings.categoryAll,
                            AppStrings.countAll),
                        _buildCategoryButton(
                            context,
                            AppStrings.categoryScience,
                            AppStrings.countScience),
                        _buildCategoryButton(context, AppStrings.categoryTech,
                            AppStrings.countTech),
                        _buildCategoryButton(context, AppStrings.categoryTech,
                            AppStrings.countFun),
                        _buildCategoryButton(context, AppStrings.categoryTrend,
                            AppStrings.countTrend),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          _buildBottomItem(context, Icons.add_circle_outline,
                              AppStrings.addSource),
                          SizedBox(height: 16.h),
                          _buildBottomItem(context, Icons.bookmark_border,
                              AppStrings.saveText),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, String title, String count) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.fromHeight(40.h),
          alignment: Alignment.centerLeft,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: context.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  '($count)',
                  style: AppTextStyles.body.copyWith(
                    color: title == AppStrings.categoryAll
                        ? context.primaryColor
                        : context.textColor,
                  ),
                ),
                if (title != AppStrings.categoryAll)
                  Icon(Icons.keyboard_arrow_down,
                      color: context.textColor, size: 24.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: context.textColor, size: 24.sp),
        SizedBox(width: 12.w),
        Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: context.textColor,
          ),
        ),
      ],
    );
  }
}
