import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/core/extensions/theme_extension.dart';
import 'package:bundle_app/presentation/widgets/custom_app_bar.dart';
import 'package:bundle_app/presentation/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_texts.dart';
import 'notifications_view_model.dart';
import 'package:get_it/get_it.dart';
import '../../../model/article_model.dart';
import '../../../services/news_service.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationsViewModel(GetIt.I<NewsService>()),
      child: const _NotificationsViewContent(),
    );
  }
}

class _NotificationsViewContent extends StatelessWidget {
  const _NotificationsViewContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          drawer: const DrawerWidget(),
          backgroundColor: context.backgroundColor,
          appBar: CustomAppBar(
            title: AppStrings.notificationsTitle,
            centerTitle: true,
            showBackButton: false,
            leading: const DrawerWidget(isDrawerButton: true),
          ),
          body: _buildBody(viewModel, context),
        );
      },
    );
  }

  Widget _buildBody(NotificationsViewModel viewModel, BuildContext context) {
    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: context.primaryColor,
        ),
      );
    }

    if (viewModel.error != null) {
      return Center(
        child: Text(
          viewModel.error!,
          style: AppTextStyles.body.copyWith(
            color: context.primaryColor,
          ),
        ),
      );
    }

    if (viewModel.notifications.isEmpty) {
      return Center(
        child: Text(
          AppStrings.errorNews,
          style: AppTextStyles.body.copyWith(
            color: context.textColor,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.notifications.length,
      itemBuilder: (context, index) {
        final article = viewModel.notifications[index];
        return _buildNotificationCard(article, context, viewModel);
      },
    );
  }

  Widget _buildNotificationCard(
      Article article, BuildContext context, NotificationsViewModel viewModel) {
    return InkWell(
      onTap: () => viewModel.markAsRead(article.url),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 60.w,
                  child: Text(
                    _formatTime(DateTime.parse(article.publishedAt)),
                    style: AppTextStyles.h2.copyWith(
                      color: context.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (article.urlToImage != null)
                            CircleAvatar(
                              radius: 12.r,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  NetworkImage(article.urlToImage!),
                            ),
                          SizedBox(width: 8.w),
                          Text(
                            article.source,
                            style: AppTextStyles.body.copyWith(
                              color: context.textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        article.title,
                        style: AppTextStyles.body.copyWith(
                          color: context.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              '•',
                              style: AppTextStyles.caption.copyWith(
                                color: context.secondaryColor,
                              ),
                            ),
                          ),
                          Text(
                            _formatDate(DateTime.parse(article.publishedAt)),
                            style: AppTextStyles.caption.copyWith(
                              color: context.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)}';
  }

  String _getMonthName(int month) {
    const months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    return months[month - 1];
  }
}
