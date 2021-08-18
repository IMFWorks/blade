import 'dart:io';

import 'package:blade/messenger/event_dispatcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:blade/container/blade_container.dart';
import 'package:blade/blade_navigator.dart';
import 'package:blade/container/page_visibility.dart';
import 'package:blade/container/overlay_entry.dart';
import 'package:blade/messenger/page_info.dart';
import 'container/blade_page.dart';
import 'container/container_manager.dart';

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

class BladeAppState extends State<BladeApp> with BladeNavigator
    implements PageEventListener {
  late ContainerManager containerManager;
  late EventDispatcher eventDispatcher;

  BladeRouteFactory get routeFactory => widget.routeFactory;
  final Set<int> _activePointers = <int>{};

  EventSender get eventSender {
    return eventDispatcher;
  }

  @override
  void initState() {
    containerManager = ContainerManager(routeFactory);
    eventDispatcher = EventDispatcher(this);
    initBladeNavigator(widget.initialRoute);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.appBuilder(WillPopScope(
        onWillPop: () async {
          final bool? canPop = topContainer.navigator?.canPop();
          if (canPop != null && canPop) {
            topContainer.navigator?.pop();
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
      for (BladeContainer container in containerManager.containers) {
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

  // PageEventListener
  void pushPage(PageInfo pageInfo) {
    push(pageInfo);
  }

  void popPage(PageInfo pageInfo) {
    pop(id: pageInfo.id);
  }

  void removePage(PageInfo pageInfo) {
    // _removeContainer(pageInfo.id, targetContainers: _pendingPopcontainers);
    // _removeContainer(pageInfo.id, targetContainers: _containers);
  }

  void onPageAppeared(PageInfo pageInfo) {
    // PageVisibilityBinding.instance
    //     .dispatchPageShowEvent(_getCurrentPageRoute());
  }

  void onPageDisappeared(PageInfo pageInfo) {
    if (topContainer.pageInfo.id != pageInfo.id) {
      return;
    }

    // PageVisibilityBinding.instance
    //     .dispatchPageHideEvent(_getCurrentPageRoute());

  }

  void onForeground() {
    // PageVisibilityBinding.instance
    //     .dispatchForegroundEvent(_getCurrentPageRoute());
  }

  void onBackground() {
    // PageVisibilityBinding.instance
    //     .dispatchBackgroundEvent(_getCurrentPageRoute());
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
