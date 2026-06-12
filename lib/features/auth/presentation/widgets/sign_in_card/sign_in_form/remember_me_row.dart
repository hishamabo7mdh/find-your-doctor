import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_strings.dart';
import 'package:project1/core/utils/app_text_styles.dart';

class RememberMeRow extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?>onChanged;
  const RememberMeRow({super.key, required this.rememberMe, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: onChanged,
          activeColor: AppColors.secondaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(5))),
          side: BorderSide(
            color: AppColors.greyText,
            width: 1.5.w
          ),
        ),
        Text(
          AppStrings.rememberAr,
              style: CustomTextStyles.poppinsRegularTextGreyText14,
        ),

        const Spacer(),

        TextButton(
          onPressed: (){},
          child: Text(
            AppStrings.forgotPasswordAr,
            style: CustomTextStyles.poppinsRegularTextGreyText14.copyWith(
              color: AppColors.secondaryColor,
            )
          ),
        )

      ]
    );
  }
}
