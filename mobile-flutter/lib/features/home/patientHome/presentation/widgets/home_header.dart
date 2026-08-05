import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildProfileButton(),

        const Spacer(),

        _buildLogoSection(userName),
      ],
    );
  }

  Widget _buildProfileButton() {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryColor,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.person_outline,
        color: AppColors.primaryColor,
        size: 24.sp,
      ),
    );
  }

  Widget _buildLogoSection(String userName) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'SMB',
              style: CustomTextStyles.poppinsExtraBoldTitleText27.copyWith(
                color: AppColors.primaryColor,
              ),
            ),

            Text(
              'مرحباً $userName',
              style: CustomTextStyles.poppinsRegularTextGreyText14.copyWith(
                color: AppColors.black,
              ),
            ),
          ],
        ),

        SizedBox(width: 10.w),

        Container(
          width: 44.w,
          height: 44.w,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add,
            color: AppColors.white,
            size: 28.sp,
          ),
        ),
      ],
    );
  }
}