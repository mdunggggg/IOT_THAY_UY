import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../di/di.dart';
import '../router/router.dart';
import '../router/router.gr.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _appRouter = getIt.get<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1),
        ),
        child: child ?? const SizedBox.shrink(),
      ),
      routerDelegate: _appRouter.delegate(
        deepLinkBuilder: (_) => DeepLink(_mapRouteToPageRouteInfo()),
      ),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
    );
  }

  List<PageRouteInfo> _mapRouteToPageRouteInfo() {
    return [const MainRoute()];
  }
}
