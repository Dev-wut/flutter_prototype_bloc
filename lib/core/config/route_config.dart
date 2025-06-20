import 'package:flutter_prototype_bloc/feature/silver_app_bar_tab/presentation/page/silver_app_bar_tab_example.dart';
import 'package:go_router/go_router.dart';

import '../../feature/home_page/home_page.dart';
import '../../feature/silver_app_bar_tab/presentation/page/silver_app_bar_tab.dart';
import '../../feature/silver_app_bar_tab/presentation/page/silver_app_bar_tab_state_full.dart';
import '../../feature/split_panel/presentation/page/split_panel.dart';
import '../../feature/split_panel/presentation/page/split_panel_example.dart';
import '../../feature/split_panel/presentation/page/three_split_panel.dart';
import '../../feature/split_panel/presentation/page/three_split_panel_example.dart';

enum AppRoutes {
  initial(name: 'initial', path: '/initial'),
  splitPanel(name: 'splitPanel', path: '/splitPanel'),
  threeSplitPanel(name: 'threeSplitPanel', path: '/threeSplitPanel'),
  splitPanelExample(name: 'splitPanelExample', path: '/splitPanelExample'),
  threeSplitPanelExample(
    name: 'threeSplitPanelExample',
    path: '/threeSplitPanelExample',
  ),
  silverAppBarTab(name: 'silverAppBarTab', path: '/silverAppBarTab'),
  silverAppBarTabStateFull(name: 'silverAppBarTabStateFull', path: '/silverAppBarTabStateFull'),
  silverAppBarTabExample(name: 'silverAppBarTabExample', path: '/silverAppBarTabExample')
  ;

  final String name;
  final String path;

  const AppRoutes({required this.name, required this.path});
}

final class RouteConfig {
  static GoRouter get router => _routes;

  static final _routes = GoRouter(
    initialLocation: AppRoutes.initial.path,
    routes: [
      GoRoute(
        name: AppRoutes.initial.name,
        path: AppRoutes.initial.path,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: AppRoutes.threeSplitPanel.name,
        path: AppRoutes.threeSplitPanel.path,
        builder: (context, state) => const ThreeSplitPanel(),
      ),
      GoRoute(
        name: AppRoutes.threeSplitPanelExample.name,
        path: AppRoutes.threeSplitPanelExample.path,
        builder: (context, state) => const ThreeSplitPanelExample(),
      ),
      GoRoute(
        name: AppRoutes.splitPanel.name,
        path: AppRoutes.splitPanel.path,
        builder: (context, state) => const SplitPanel(),
      ),
      GoRoute(
        name: AppRoutes.splitPanelExample.name,
        path: AppRoutes.splitPanelExample.path,
        builder: (context, state) => const SplitPanelExample(),
      ),
      GoRoute(
        name: AppRoutes.silverAppBarTabStateFull.name,
        path: AppRoutes.silverAppBarTabStateFull.path,
        builder: (context, state) => const SilverAppBarTabStateFull(),
      ),
      GoRoute(
        name: AppRoutes.silverAppBarTabExample.name,
        path: AppRoutes.silverAppBarTabExample.path,
        builder: (context, state) => const SilverAppBarTabExample(),
      ),
      GoRoute(
        name: AppRoutes.silverAppBarTab.name,
        path: AppRoutes.silverAppBarTab.path,
        builder: (context, state) => const SilverAppBarTab(),
      ),
    ],
  );
}
