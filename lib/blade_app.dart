import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:blade/container/blade_container.dart';
import 'package:blade/container/overlay_entry.dart';
import 'container/blade_page.dart';
import 'navigator/blade_navigator_impl.dart';

typedef BladeAppBuilder = Widget Function(Widget home);
typedef PageBuilder = Widget Function(BuildContext context, RouteSettings settings);

class BladeApp extends StatefulWidget {
  const BladeApp(this.routeFactory,
      {BladeAppBuilder? appBuilder, String? initialRoute})
      : appBuilder = appBuilder ?? _materialAppBuilder,
        initialRoute = initialRoute ?? '/';

  final BladeRouteFactory routeFactory;
  final BladeAppBuilder appBuilder;
  final String initialRoute;

  static Widget _materialAppBuilder(Widget home) {
    return MaterialApp(home: home);
  }

  @override
  State<StatefulWidget> createState() => BladeAppState();
}

class BladeAppState extends State<BladeApp> {
  late BladeNavigatorImpl navigator;
  @override
  void initState() {
    super.initState();

    navigator = BladeNavigatorImpl(widget.routeFactory, widget.initialRoute);
  }

  @override
  Widget build(BuildContext context) {
    return widget.appBuilder(Overlay(
    key: overlayKey,
    initialEntries: _initialEntries(),
    ));
  }

  List<OverlayEntry> _initialEntries() {
    final List<OverlayEntry> entries = <OverlayEntry>[];
    final overlayState = overlayKey.currentState;
    if (overlayState == null) {
      for (BladeContainer container in navigator.containerManager.containers) {
        final ContainerOverlayEntry entry = ContainerOverlayEntry(container);
        entries.add(entry);
      }
    }
    return entries;
  }
}
