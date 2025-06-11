import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:profit_made_clear_254_t/stranice/one/my_category_page.dart';

class LastScreen extends StatelessWidget {
  const LastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.blue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
    );

    return Scaffold(
      appBar: AppBarApp(
        title: 'Settings',
        centerTitle: false,
        isSsss: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: [
                _SettingsButton(
                  icon: 'assets/icons/pppppp.svg',
                  title: "Privacy\nPolicy",
                  onTap: () {},
                  style: buttonStyle,
                ),
                _SettingsButton(
                  icon: 'assets/icons/fff.svg',
                  title: "Terms\nof Use",
                  onTap: () {},
                  style: buttonStyle,
                ),
                _SettingsButton(
                  icon: 'assets/icons/mmmm.svg',
                  title: "Support",
                  onTap: () {},
                  style: buttonStyle,
                ),
                _SettingsButton(
                  icon: 'assets/icons/ff.svg',
                  title: "Share",
                  onTap: () {},
                  style: buttonStyle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final ButtonStyle style;

  const _SettingsButton({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 16.w * 2 - 12.w) / 2,
      child: OutlinedButton(
        onPressed: onTap,
        style: style,
        child: Row(
          children: [
            SvgPicture.asset(icon),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
