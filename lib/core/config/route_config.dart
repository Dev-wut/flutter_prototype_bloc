import 'package:go_router/go_router.dart';

import '../../feature/home_page/home_page.dart';
import '../../feature/split_panel/presentation/page/split_Panel.dart';
import '../../feature/split_panel/presentation/page/split_panel_example.dart';
import '../../feature/split_panel/presentation/page/three_split_panel.dart';
import '../../feature/split_panel/presentation/page/three_split_panel_example.dart';

enum AppRoutes {
  initial(name: 'initial', path: '/initial'),
  splitPanel(
    name: 'splitPanel',
    path: '/splitPanel',
  ),
  threeSplitPanel(
    name: 'threeSplitPanel',
    path: '/threeSplitPanel',
  ),
  splitPanelExample(
    name: 'splitPanelExample',
    path: '/splitPanelExample',
  ),
  threeSplitPanelExample(name: 'threeSplitPanelExample', path: '/threeSplitPanelExample');

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
    ],
  );
}
