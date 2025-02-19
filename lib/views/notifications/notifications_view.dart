import 'package:bundle_app/core/extensions/theme_extension.dart';
import 'package:bundle_app/model/notification_model.dart';
import 'package:bundle_app/services/notifications_service.dart';
import 'package:bundle_app/widgets/custom_app_bar.dart';
import 'package:bundle_app/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_texts.dart';
import 'notifications_view_model.dart';
import 'package:get_it/get_it.dart';
import '../../model/article_model.dart';
import '../../services/news_service.dart';

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
  const _NotificationsViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          drawer: const DrawerWidget(),
          backgroundColor: context.backgroundColor,
          appBar: CustomAppBar(
            title: 'BİLDİRİMLER',
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
          'Bildirim bulunmuyor',
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
        return NotificationCard(
          notification: NotificationModel(
            id: article.url,
            title: article.title,
            message: article.description ?? '',
            category: article.category.toString(),
            timestamp: DateTime.parse(article.publishedAt),
            isRead: false,
            source: article.source,
            sourceImageUrl: article.urlToImage ?? '',
          ),
          onTap: () => viewModel.markAsRead(article.url),
        );
      },
    );
  }
}

// Bildirim kartı widget'ı
class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    required this.notification,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saat (sol tarafta)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol taraf - Saat
                SizedBox(
                  width: 60.w,
                  child: Text(
                    _formatTime(notification.timestamp),
                    style: AppTextStyles.h2.copyWith(
                      color: context.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Sağ taraf - İçerik
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kaynak ve logo
                      Row(
                        children: [
                          // Logo
                          CircleAvatar(
                            radius: 12.r,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                              notification.sourceImageUrl ?? '',
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Kaynak adı
                          Text(
                            notification.source,
                            style: AppTextStyles.body.copyWith(
                              color: context.textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Başlık
                      Text(
                        notification.title,
                        style: AppTextStyles.body.copyWith(
                          color: context.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Kategori ve tarih
                      Row(
                        children: [
                          Text(
                            notification.category,
                            style: AppTextStyles.caption.copyWith(
                              color: context.secondaryColor,
                            ),
                          ),
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
                            '14 Şubat',
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

  String _formatTime(DateTime timestamp) {
    String hour = timestamp.hour.toString().padLeft(2, '0');
    String minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
