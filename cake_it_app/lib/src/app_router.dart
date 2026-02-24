import 'package:cake_it_app/src/features/cake_detail/cake_details_view.dart';
import 'package:cake_it_app/src/features/cake_list/cake_list_view.dart';
import 'package:cake_it_app/src/models/cake.dart';
import 'package:cake_it_app/src/route_names.dart';
import 'package:cake_it_app/src/settings/settings_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: RouteNames.cakeList,
        builder: (context, state) => const CakeListView(),
      ),
      GoRoute(
        path: '/cake/:index',
        name: RouteNames.cakeDetail,
        builder: (context, state) {
          final index = int.parse(state.pathParameters['index']!);
          final cake = state.extra! as Cake;
          return CakeDetailsView(index: index, cake: cake);
        },
      ),
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}
