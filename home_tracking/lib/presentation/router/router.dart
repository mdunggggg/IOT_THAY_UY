import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_route/src/route/auto_route_config.dart';
import 'package:injectable/injectable.dart';

import 'router.gr.dart';


@injectable
@AutoRouterConfig()
class AppRouter extends $AppRouter{
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: MainRoute.page, children: [
      CustomRoute(page: HomeRoute.page, transitionsBuilder: TransitionsBuilders.fadeIn),
      CustomRoute(page: ActionRoute.page, transitionsBuilder: TransitionsBuilders.fadeIn),
      CustomRoute(page: ProfileRoute.page, transitionsBuilder: TransitionsBuilders.fadeIn),
      CustomRoute(page: HomeRoute.page, transitionsBuilder: TransitionsBuilders.fadeIn),
    ]),
  ];

}