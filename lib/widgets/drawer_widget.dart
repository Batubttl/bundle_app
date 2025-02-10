import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants/app_constants.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75, // Drawer genişliği
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            // Üst Kısım
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 20.r,
                        child: Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Giriş Yap',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon:
                        Icon(Icons.settings, color: Colors.white, size: 24.sp),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Dolar Kuru ve Hava Durumu
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '35,958 USD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.cloud, color: Colors.white, size: 20.sp),
                      SizedBox(width: 4.w),
                      Text(
                        '6° ANKARA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Kategoriler ve Alt Kısım
            Expanded(
              child: Column(
                children: [
                  // Kategoriler (Sabit)
                  Column(
                    children: [
                      _buildCategoryItem('TÜMÜ', '19'),
                      _buildCategoryItem('BİLİM', '6'),
                      _buildCategoryItem('TEKNOLOJİ', '4'),
                      _buildCategoryItem('EĞLENCE', '1'),
                      _buildCategoryItem('GÜNDEM', '8'),
                    ],
                  ),

                  // Boşluk (Esnek)
                  const Spacer(),

                  // Alt Kısım (Sabit)
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        _buildBottomItem(
                            Icons.add_circle_outline, 'Kaynak Ekle'),
                        SizedBox(height: 16.h),
                        _buildBottomItem(
                            Icons.bookmark_border, 'Kaydedilenler'),
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
    );
  }

  Widget _buildCategoryItem(String title, String count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                '($count)',
                style: TextStyle(
                  color: title == 'TÜMÜ' ? Colors.red : Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              if (title != 'TÜMÜ')
                Icon(Icons.keyboard_arrow_down,
                    color: Colors.white, size: 24.sp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 24.sp),
        SizedBox(width: 12.w),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
