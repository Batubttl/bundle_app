import 'package:bundle_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/theme/app_texts.dart';
import '../../widgets/custom_app_bar.dart';
import 'currency_view_model.dart';

class CurrencyDetailView extends StatelessWidget {
  const CurrencyDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<CurrencyViewModel>(),
      child: const _CurrencyDetailContent(),
    );
  }
}

class _CurrencyDetailContent extends StatelessWidget {
  const _CurrencyDetailContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: CustomAppBar(
            title: 'Döviz Kurları',
            centerTitle: true,
            showBackButton: false,
            leading: CloseButton(color: context.textColor),
            backgroundColor: AppColors.black,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: context.textColor,
                  size: 24.sp,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: context.textColor,
                  size: 24.sp,
                ),
                onPressed: viewModel.refreshRates,
              ),
            ],
          ),
          body: viewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : viewModel.error != null
                  ? Center(child: Text(viewModel.error!))
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          _buildCurrencyCard(
                            context,
                            flag: '🇺🇸',
                            code: 'USD',
                            name: 'Amerikan Doları',
                            rate: viewModel.usdRate,
                          ),
                          SizedBox(height: 12.h),
                          _buildCurrencyCard(
                            context,
                            flag: '🇪🇺',
                            code: 'EUR',
                            name: 'Euro',
                            rate: viewModel.eurRate,
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildCurrencyCard(
    BuildContext context, {
    required String flag,
    required String code,
    required String name,
    required String rate,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Text(
            flag,
            style: TextStyle(fontSize: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: AppTextStyles.h2.copyWith(
                    color: context.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  name,
                  style: AppTextStyles.body.copyWith(
                    color: context.textColor.withValues(),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₺$rate',
            style: AppTextStyles.h2.copyWith(
              color: context.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }
}
