import 'package:bundle_app/model/notification_model.dart';
import 'package:bundle_app/widgets/custom_app_bar.dart';
import 'package:bundle_app/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'notifications_view_model.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationsViewModel(),
      child: Consumer<NotificationsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            drawer: const DrawerWidget(),
            backgroundColor: Colors.black,
            appBar: CustomAppBar(
              title: 'BİLDİRİMLER',
              centerTitle: true,
              showBackButton: false,
              leading: Builder(
                builder: (BuildContext context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.white, size: 24.sp),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.white, size: 24.sp),
                  onPressed: () {
                    // Ayarlar işlevi
                  },
                ),
              ],
            ),
            body: _buildBody(viewModel),
          );
        },
      ),
    );
  }

  Widget _buildBody(NotificationsViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(
        child: Text(
          viewModel.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (viewModel.notifications.isEmpty) {
      return const Center(
        child: Text(
          'Bildirim bulunmuyor',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.notifications.length,
      itemBuilder: (context, index) {
        final notification = viewModel.notifications[index];
        return NotificationCard(
          notification: notification,
          onTap: () => viewModel.markAsRead(notification.id),
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
                  width: 45.w,
                  child: Text(
                    _formatTime(notification.timestamp),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 24.sp,
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
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Başlık
                      Text(
                        notification.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Kategori ve tarih
                      Row(
                        children: [
                          Text(
                            notification.category,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              '•',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          Text(
                            '14 Şubat',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
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
