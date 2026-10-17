import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_text_styles.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_action_card.dart';

class FastProcedures extends StatelessWidget {
  const FastProcedures({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'إجراءات سريعة',
          textAlign: TextAlign.right,
          style: CustomTextStyles.poppinsExtraBoldTitleText27.copyWith(
            fontSize: 17.sp,
          ),
        ),

        SizedBox(height: 14.h),
        RowInFastProcedures(
          textOne: 'تسجيل دكتور',
          textOneSub: 'Register Doctor',
          iconOne: Icons.person_add_alt_1_outlined,
          onTapOne: () {
            context.go(AppRouter.registerDoctor);
          },
          textTwo: 'إدارة الأطباء',
          textTwoSub: 'Manage Doctors',
          icontwo: Icons.groups_outlined,
          onTapTwo: () {
            context.go(AppRouter.adminDoctors);
          },
        ),
        SizedBox(height: 14.h),

        RowInFastProcedures(
          textOne: 'المواعيد',
          textOneSub: 'Appointments',
          iconOne: Icons.calendar_month_outlined,
          onTapOne: () {
            context.go(AppRouter.adminAppointments);
          },
          textTwo: 'الإعدادات',
          textTwoSub: 'Settings',
          icontwo: Icons.settings_outlined,
          onTapTwo: () {
            context.go(AppRouter.adminSettings);
          },
        ),
      ],
    );
  }
}

class RowInFastProcedures extends StatelessWidget {
  final String textOne;
  final String textOneSub;
  final String textTwo;
  final String textTwoSub;
  final IconData iconOne;
  final IconData icontwo;
  final VoidCallback onTapOne;
  final VoidCallback onTapTwo;
  const RowInFastProcedures({
    super.key,
    required this.textOne,
    required this.textOneSub,
    required this.textTwo,
    required this.textTwoSub,
    required this.iconOne,
    required this.icontwo,
    required this.onTapOne,
    required this.onTapTwo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AdminActionCard(
            title: textOne,
            subtitle: textOneSub,
            icon: iconOne,
            onTap: onTapOne,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AdminActionCard(
            title: textTwo,
            subtitle: textTwoSub,
            icon: icontwo,
            onTap: onTapTwo,
          ),
        ),
      ],
    );
  }
}
