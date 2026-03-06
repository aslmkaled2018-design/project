import 'package:flutter/material.dart';
import 'welcomepagetemplate.dart';

class WelcomeScreens extends StatefulWidget {
  const WelcomeScreens({super.key});

  @override
  State<WelcomeScreens> createState() => _WelcomeScreensState();
}

class _WelcomeScreensState extends State<WelcomeScreens> {
  final PageController controller = PageController();
  int nextPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: controller,
            onPageChanged: (val) {
              setState(() {
                nextPage = val;
              });
            },
            children: [
              WelcomePageTemplate(
                image: 'images/plante1.jpg',
                icon: Icons.camera_alt_outlined,
                iconColor: const Color.fromARGB(255, 217, 255, 224),
                title: 'تعرف على أي نبتة بصورة واحدة',
                desc: 'التقط صورة لأي نبتة واحصل على معلومات شاملة عنها فوراً',
                overlayOpacity: 0.7,
                onNext: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              WelcomePageTemplate(
                image: 'images/plan2.jpg',
                icon: Icons.eco_outlined,
                iconColor: const Color.fromARGB(255, 232, 255, 199),
                title: 'شخص مشاكل نبتاتك واحصل على علاج فوري',
                desc: 'خبير AI متاح 24/7 لمساعدتك في حل مشاكل نباتاتك',
                overlayOpacity: 0.9,

                onNext: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              WelcomePageTemplate(
                image: 'images/page3.png',
                icon: Icons.date_range_outlined,
                iconColor: const Color.fromARGB(255, 255, 252, 180),
                title: 'لن تنسى سقي نباتاتك بعد اليوم',
                desc: 'تذكيرات ذكية ومخصصة لكل نبتة حسب احتياجاتها',
                overlayOpacity: 0.7,
                isLastPage: true,
                onNext: () {},
              ),
            ],
          ),

          Positioned(
            bottom: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: nextPage == index ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        nextPage == index
                            ? const Color.fromARGB(255, 42, 50, 0)
                            : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
