import 'package:bundle_app/core/constants/api_constants.dart';
import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/core/di/locator.dart';
import 'package:bundle_app/core/extensions/theme_extension.dart';
import 'package:bundle_app/core/theme/app_texts.dart';
import 'package:bundle_app/presentation/views/drawer/weather_viewmodel.dart';
import 'package:bundle_app/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../services/weather_service.dart';
// ... diğer importlar ...

class WeatherDetailView extends StatelessWidget {
  const WeatherDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          WeatherViewModel(locator<WeatherService>())..getWeatherDetails(),
      child: const WeatherDetailContent(),
    );
  }
}

class WeatherDetailContent extends StatelessWidget {
  const WeatherDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Scaffold(
            backgroundColor: context.backgroundColor,
            appBar: CustomAppBar(
              centerTitle: true,
              title: AppStrings.weatherTitle,
              showBackButton: false,
              leading: CloseButton(),
              backgroundColor: context.backgroundColor,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final weatherData = viewModel.weatherData;
        if (weatherData == null) {
          return Scaffold(
            backgroundColor: context.backgroundColor,
            appBar: const CustomAppBar(
              title: AppStrings.weatherTitle,
              showBackButton: false,
              leading: CloseButton(),
            ),
            body: Center(
              child: Text(
                'Veri bulunamadı',
                style: AppTextStyles.body.copyWith(color: context.textColor),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: const CustomAppBar(
            title: AppStrings.weatherTitle,
            showBackButton: false,
            leading: CloseButton(),
            backgroundColor: Colors.black,
          ),
          body: ListView(
            children: [
              // Şehir ve Sıcaklık
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      '${ApiConstants.weatherIconBaseUrl}/${weatherData.icon}.png',
                      width: 100.w,
                      height: 100.h,
                      color: context.whiteColor,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      AppStrings.cityName,
                      style: AppTextStyles.h2.copyWith(
                        color: context.textColor,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      weatherData.temperature,
                      style: TextStyle(
                        fontSize: 96.sp,
                        color: context.textColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

              // Saatlik Tahmin
              SizedBox(
                height: 150.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherData.hourlyForecast.length,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemBuilder: (context, index) {
                    final hourly = weatherData.hourlyForecast[index];
                    return Container(
                      width: 80.w,
                      margin: EdgeInsets.only(right: 12.w),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            hourly.time,
                            style: AppTextStyles.body.copyWith(
                              color: context.textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Image.network(
                            '${ApiConstants.weatherIconBaseUrl}/${hourly.icon}.png',
                            width: 40.w,
                            height: 40.h,
                            color: context.textColor,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            hourly.temperature,
                            style: AppTextStyles.body.copyWith(
                              color: context.textColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Haftalık Görünüm
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.weatherWeek,
                      style: AppTextStyles.h1.copyWith(
                        color: context.textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ...weatherData.dailyForecast.map((daily) => Padding(
                          padding: EdgeInsets.only(bottom: 24.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                daily.day,
                                style: AppTextStyles.body.copyWith(
                                  color: context.textColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Row(
                                children: [
                                  Image.network(
                                    '${ApiConstants.weatherIconBaseUrl}/${daily.icon}.png',
                                    width: 30.w,
                                    height: 30.h,
                                    color: context.textColor,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    daily.temperature,
                                    style: AppTextStyles.body.copyWith(
                                      color: context.textColor,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close, color: context.textColor),
      onPressed: () => Navigator.pop(context),
    );
  }
}
