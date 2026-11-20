

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ngo/core/constrains/app_color.dart';
import 'package:ngo/core/log/debug_logging.dart';
import 'package:ngo/features/dashboard/presentation/view/profile_page.dart';
import 'package:ngo/features/dashboard/presentation/view/settings_page.dart';
import 'package:ngo/features/survey/presentation/pages/add_survey_page.dart';
import 'package:ngo/features/survey/presentation/pages/suerveys_page.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../../di.dart';
import '../../../notification/presentation/getx/notification_controller.dart';
import '../../../notification/presentation/pages/notification_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState2 extends State<Dashboard> {

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const Center(
          child: Text('Dashboard'),
        ),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () => {
            print('Floating Action Button')
          },
          child: const Icon(Icons.add)
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class _DashboardState extends State<Dashboard> {

  int selectedIndex = 0;
  bool heart = false;



  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _screens = [
    const SurveyApp(),
    const NotificationPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBody: false,
        /*appBar: AppBar(
          title: const Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 18),),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),*/
        body: /*SafeArea(
          child: PageView(
            children: const [
              Center(child: Text('Home')),
              Center(child: Text('Star')),
              Center(child: Text('Style')),
              Center(child: Text('Profile')),
            ],
          ),
        ),*/
        IndexedStack(
          index: selectedIndex,
          children: _screens,
        ),

        bottomNavigationBar: StylishBottomBar(
          option: AnimatedBarOptions(
            // iconSize: 32,
            // barAnimation: BarAnimation.liquid,
            iconStyle: IconStyle.animated,

            // opacity: 0.3,
          ),
          /*option: DotBarOptions(
            dotStyle: DotStyle.tile,
            gradient: const LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.pink,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),*/
          items: [
            BottomBarItem(
              icon: const Icon(Icons.house_outlined),
              selectedIcon: const Icon(Icons.house_rounded, color: AppColor.primary,),
              selectedColor: AppColor.primary,
              unSelectedColor: Colors.grey,
              title: const Text('Home'),
              //badge: const Text('9+'),
              //showBadge: true,
              badgeColor: AppColor.primary,
              badgePadding: const EdgeInsets.only(left: 4, right: 4),
            ),
            BottomBarItem(
              icon: const Icon(Icons.notifications),
              selectedIcon: const Icon(Icons.notifications_active, color: AppColor.primary,),
              selectedColor: AppColor.primary,
              // unSelectedColor: Colors.purple,
              // backgroundColor: Colors.orange,
              badge: BadgeText(),
              showBadge: true,
              title: const Text('Notification'),
              badgeColor: AppColor.red,
            ),
            BottomBarItem(
                icon: const Icon(
                  Icons.person_outline,
                ),
                selectedIcon: const Icon(
                  Icons.person,color: AppColor.primary,
                ),
                selectedColor: AppColor.primary,
                title: const Text('Profile')),
            BottomBarItem(
                icon: const Icon(
                  Icons.settings,
                ),
                selectedIcon: const Icon(
                  Icons.settings,color: AppColor.primary,
                ),
                selectedColor: AppColor.primary,
                title: const Text('Setting')),
          ],
          hasNotch: true,
          fabLocation: StylishBarFabLocation.center,
          currentIndex: selectedIndex,
          notchStyle: NotchStyle.circle,
          onTap: (index) {
            if (index == selectedIndex) return;
            //controller.jumpToPage(index);
            DebugLogging.log("index: $index");
            setState(() {
              selectedIndex = index;
            });
          },
        ),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () {
            setState(() {
              heart = !heart;
            });
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => const AddSurveyPage(),
                fullscreenDialog: true,
              )
            );
          },
          backgroundColor: AppColor.primary,
          child: Icon(
            //heart ? CupertinoIcons.add_circled_solid : CupertinoIcons.add_circled,
            CupertinoIcons.add,
            color: AppColor.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        /*StylishBottomBar(
          option: AnimatedBarOptions(
            iconStyle: IconStyle.Default, // Set your default icon style here
          ),
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomBarItem(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              title: const Text('Home'),
              selectedColor: Colors.red,
            ),
            BottomBarItem(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              title: const Text('Home'),
              selectedColor: Colors.red,
            ),
            BottomBarItem(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              title: const Text('Profile'),
              selectedColor: Colors.blue,
            ),
          ],
        ),*/
      ),
    );
  }
}

class BadgeText extends StatefulWidget {
  const BadgeText({super.key});

  @override
  State<BadgeText> createState() => _BadgeTextState();
}

class _BadgeTextState extends State<BadgeText> {

  final NotificationController controller = Get.put(getIt<NotificationController>());

  @override
  void initState() {
    controller.fetchNotifications("email");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Text("${controller.notifications.length}");
    });
  }
}

