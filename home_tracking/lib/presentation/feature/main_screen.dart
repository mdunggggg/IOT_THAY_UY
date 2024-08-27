import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:home_tracking/presentation/router/router.gr.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        ActionRoute(),
        DataRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = context.tabsRouter;
        return Scaffold(
          body: child,
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            backgroundColor: Colors.white,
            items:  [
              SalomonBottomBarItem(icon: const Icon(Icons.home_outlined), title: const Text("Home"), selectedColor: Colors.blue),
              SalomonBottomBarItem(icon: const Icon(Icons.art_track_sharp), title: const Text("Search"), selectedColor: Colors.red),
              SalomonBottomBarItem(icon: const Icon(Icons.data_thresholding_outlined), title: const Text("Add"), selectedColor: Colors.green),
              SalomonBottomBarItem(icon: const Icon(Icons.person_outline), title: const Text("Profile"), selectedColor: Colors.purple),
            ],
          ),
        );
      }
    );
  }
}
