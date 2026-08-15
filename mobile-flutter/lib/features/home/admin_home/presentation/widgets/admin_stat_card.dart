import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminStatCard extends StatelessWidget {
  final String value;
  final String title;
  final String change;
  final IconData icon;

  const AdminStatCard({
    super.key,
    required this.value,
    required this.title,
    required this.change,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105.h,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFF51B2AA),
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Text(
              change,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),

                SizedBox(height: 5.h),

                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.9),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}