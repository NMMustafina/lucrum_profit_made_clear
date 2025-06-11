import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:profit_made_clear_254_t/stranice/one/part_o_page.dart';

import '../stranice/analytics_page.dart';
import '../stranice/last_screen.dart';
import 'color_asf.dart';
import 'new_buti.dart';

class MainBotomBar extends StatefulWidget {
  const MainBotomBar({super.key, this.indexScr = 0});

  final int indexScr;

  @override
  State<MainBotomBar> createState() => MainBotomBarState();
}

class MainBotomBarState extends State<MainBotomBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexScr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 110.h,
        width: double.infinity,
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(
              color: Color(0xff2e2e2e),
              width: 1.w,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: buildNavItem(0, 'assets/images/mas.svg')),
            Expanded(child: buildNavItem(1, 'assets/images/gbf.svg')),
            Expanded(child: buildNavItem(2, 'assets/images/pl.svg')),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(int index, String iconPath) {
    bool isActive = _currentIndex == index;

    return NewMotiBut(
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: isActive
                ? BoxDecoration(
                    color: ColorAsf.blue,
                    borderRadius: BorderRadius.circular(200))
                : null,
            child: SvgPicture.asset(
              iconPath,
              width: 30.w,
              height: 30.h,
              color: isActive ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }

  final _pages = <Widget>[
     PartOPage(),
     AnalyticsPage(),
    LastScreen(),
  ];
}
