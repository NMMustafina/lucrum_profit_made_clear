import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'oksad_page.dart';

class BonPage extends StatefulWidget {
  const BonPage({super.key});

  @override
  State<BonPage> createState() => _BonPageState();
}

class _BonPageState extends State<BonPage> {
  PageController pageController = PageController();
  List<OnBordik> asssdfd = [
    OnBordik(
      title: 'Organize & Conquer',
      desc: 'Group products by categories to track performance smarter',
      widgwe: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Image.asset('assets/images/rew.png'),
            SizedBox(height: 4.h),
            Image.asset('assets/images/q.png'),
            SizedBox(height: 4.h),
            Image.asset('assets/images/w.png'),
            SizedBox(height: 4.h),
            Image.asset('assets/images/e.png'),
            SizedBox(height: 4.h),
            Image.asset('assets/images/r.png'),
          ],
        ),
      ),
    ),
    OnBordik(
      title: 'Profit in Details',
      desc:
          'Add products, set costs, and revenue — see what’s driving your success',
      widgwe: Column(
        children: [
          Image.asset('assets/images/qwf.png', height: 120.h),
          SizedBox(height: 16.h),
          Image.asset('assets/images/y.png', height: 172.h),
          SizedBox(height: 16.h),
          Image.asset('assets/images/ds.png', height: 120.h),
        ],
      ),
    ),
    OnBordik(
      title: 'Numbers Tell Stories',
      desc: 'Spot trends, top performers, and leaks with interactive charts. ',
      widgwe: Center(child: Image.asset('assets/images/qweas.png')),
    ),
    OnBordik(
      title: 'Numbers Tell Stories',
      desc: 'Spot trends, top performers, and leaks with interactive charts. ',
      widgwe: Center(child: Image.asset('assets/images/qweas.png')),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: asssdfd.length,
      itemBuilder: (context, index) {
        final s = asssdfd[index];
        return CategoryInfoScreen(
          sfdsdf: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainBotomBar(),
              ),
                  (protected) => false,
            );
          },
          asfd: index == asssdfd.length - 1,
          imageas: s.widgwe ?? SizedBox(),
          click: () {
            if (index < asssdfd.length - 1) {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          title: s.title ?? '',
          desc: s.desc ?? '',
        );
      },
    );
  }
}

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key, required this.next});

  final Function() next;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Restore Purchase",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      GestureDetector(
                        onTap: next,
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // Image

                Image.asset(
                  'assets/images/hhh.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            // Top Bar

            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/images/ddd.svg'),
                        SizedBox(width: 8.w),
                        Text(
                          "Unlock the analytics section",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Purchase Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Get Premium for \$0.99",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer Links
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text("Terms of use",
                              style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Privacy Policy",
                              style: TextStyle(color: Colors.white)),
                        ),
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
}

class OnBordik {
  final String? title;
  final String? desc;
  final Widget? widgwe;

  OnBordik({
    this.title,
    this.desc,
    this.widgwe,
  });
}

class CategoryInfoScreen extends StatelessWidget {
  const CategoryInfoScreen({
    super.key,
    required this.title,
    required this.desc,
    required this.click,
    required this.imageas,
    required this.sfdsdf,
    this.asfd = false,
  });

  final String title;
  final String desc;
  final Function() click;
  final Function() sfdsdf;
  final Widget imageas;
  final bool asfd;

  @override
  Widget build(BuildContext context) {
    return asfd
        ? PremiumScreen(next: sfdsdf)
        : Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.72,
                    child: Image.asset(
                      'assets/images/asdwe.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: SafeArea(child: imageas
                      // Column(
                      //   children: [
                      //     Image.asset('assets/images/rew.png'),
                      //     SizedBox(height: 4.h),
                      //     Image.asset('assets/images/q.png'),
                      //     SizedBox(height: 4.h),
                      //     Image.asset('assets/images/w.png'),
                      //     SizedBox(height: 4.h),
                      //     Image.asset('assets/images/e.png'),
                      //     SizedBox(height: 4.h),
                      //     Image.asset('assets/images/r.png'),
                      //   ],
                      // ),
                      ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    // padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Center(
                          child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          desc,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton(
                            onPressed: click,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Continue",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
