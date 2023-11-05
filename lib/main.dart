import 'package:app_vhc/container.dart';
import 'package:app_vhc/event/app_events.dart';
import 'package:app_vhc/screen/_util/scroll_behavior.dart';
import 'package:app_vhc/screen/camera/screen.dart';
import 'package:app_vhc/screen/home/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fc/flutter_fc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final container = AppContainer();

  WidgetsBinding.instance.deferFirstFrame();
  Future(() async {
    await container.eventBus.stream
        .map((ev) => ev is AppLayoutReadyEvent)
        .first;
    WidgetsBinding.instance.allowFirstFrame();
  });

  runApp(App(container: container));
}

class App extends FCWidget {
  final AppContainer container;
  const App({required this.container, super.key});

  @override
  Widget build(BuildContext context) {
    final router = useMemo(
      () => GoRouter(initialLocation: kInitialRoute, routes: kRoutes),
      const [],
    );

    return MaterialApp.router(
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      builder: (_, child) => Provider<AppContainer>.value(
        value: container,
        child: ScrollConfiguration(
          behavior: const AppScrollBehavior(),
          child: child ?? const SizedBox(),
        ),
      ),
    );
  }
}

class AppLayout extends SingleChildStatelessWidget {
  const AppLayout({super.child, super.key});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final AppContainer(:eventBus) = Provider.of<AppContainer>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventBus.add(const AppLayoutReadyEvent());
    });
    return child ?? const SizedBox();
  }
}

const kInitialRoute = "/home";
final kRoutes = <RouteBase>[
  ShellRoute(
    builder: (_, state, child) => AppLayout(child: child),
    routes: [
      GoRoute(
        path: "/home",
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: "/camera",
        builder: (context, state) => const CameraScreen(),
      ),
    ],
  )
];
