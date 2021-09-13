import 'package:blade/navigator/core/overlay_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'container/blade_page.dart';
import 'navigator/blade_navigator_impl.dart';

typedef BladeAppBuilder = Widget Function(Widget home);
typedef PageBuilder = Widget Function(BuildContext context, RouteSettings settings);

final overlayKey = GlobalKey<OverlayState>();

class BladeApp extends StatefulWidget {
  const BladeApp(this.routeFactory,
      {String? initialRoute})
      :initialRoute = initialRoute ?? '/';

  final BladeRouteFactory routeFactory;
  final BladeAppBuilder appBuilder = _materialAppBuilder;
  final String initialRoute;

  static Widget _materialAppBuilder(Widget home) {
    return MaterialApp(home: home);
  }

  @override
  State<StatefulWidget> createState() => BladeAppState();
}

class BladeAppState extends State<BladeApp> {
  late OverlayStack stack;
  late BladeNavigatorImpl navigator;

  @override
  void initState() {
    super.initState();

    stack = OverlayStack(overlayKey);
    navigator = BladeNavigatorImpl(widget.routeFactory, widget.initialRoute, stack);
  }

  @override
  Widget build(BuildContext context) {
    final initialEntries = stack.initialEntries(navigator.containerManager.containers);
    return widget.appBuilder(
        Overlay(key: overlayKey, initialEntries: initialEntries));
  }
}