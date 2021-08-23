import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:blade/container/blade_container.dart';
import 'package:blade/container/page_visibility.dart';
import 'package:blade/container/overlay_entry.dart';
import 'container/blade_page.dart';
import 'navigator/hybrid_navigator.dart';

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

class BladeAppState extends State<BladeApp>   {
  late HybridNavigator hybridNavigator;
  final Set<int> _activePointers = <int>{};


  @override
  void initState() {
    hybridNavigator = HybridNavigator(widget.routeFactory, widget.initialRoute);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.appBuilder(WillPopScope(
        onWillPop: () async {
          final bool? canPop = hybridNavigator.topContainer.canPop();
          if (canPop != null && canPop) {
            hybridNavigator.topContainer.pop();
            return true;
          }
          return false;
        },
        child: Listener(
            onPointerDown: _handlePointerDown,
            onPointerUp: _handlePointerUpOrCancel,
            onPointerCancel: _handlePointerUpOrCancel,
            child: Overlay(
              key: overlayKey,
              initialEntries: _initialEntries(),
            ))));
  }

  List<OverlayEntry> _initialEntries() {
    final List<OverlayEntry> entries = <OverlayEntry>[];
    final OverlayState? overlayState = overlayKey.currentState;
    if (overlayState == null) {
      for (BladeContainer container in hybridNavigator.containerManager.containers) {
        final ContainerOverlayEntry entry = ContainerOverlayEntry(container);
        entries.add(entry);
      }
    }
    return entries;
  }

  void _handlePointerDown(PointerDownEvent event) {
    _activePointers.add(event.pointer);
  }

  void _handlePointerUpOrCancel(PointerEvent event) {
    _activePointers.remove(event.pointer);
  }

  void _cancelActivePointers() {
    final instance = WidgetsBinding.instance;
    if (instance != null) {
      _activePointers.toList().forEach(instance.cancelPointer);
    }
  }
}

class BladeNavigatorObserver extends NavigatorObserver {
  List<BladePage<dynamic>> _pageList;
  String _uniqueId;

  BladeNavigatorObserver(this._pageList, this._uniqueId);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    //handle internal route
    PageVisibilityBinding.instance.dispatchPageShowEvent(route);
    PageVisibilityBinding.instance.dispatchPageHideEvent(previousRoute);
    super.didPush(route, previousRoute);
    _disablePanGesture();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      PageVisibilityBinding.instance.dispatchPageHideEvent(route);
      PageVisibilityBinding.instance.dispatchPageShowEvent(previousRoute);
    }
    super.didPop(route, previousRoute);
    _enablePanGesture();
  }

  bool canDisable = true;

  void _disablePanGesture() {
    if (Platform.isIOS) {
      if (_pageList.length > 1 && canDisable) {
        // BladeNavigator.of().enablePanGesture(_uniqueId, false);
        canDisable = false;
      }
    }
  }

  void _enablePanGesture() {
    if (Platform.isIOS) {
      if (_pageList.length == 1) {
        // BladeNavigator.of().enablePanGesture(_uniqueId, true);
        canDisable = true;
      }
    }
  }
}
