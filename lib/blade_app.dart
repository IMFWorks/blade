import 'dart:async';
import 'dart:io';

import 'package:blade/messenger/event_dispatcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:uuid/uuid.dart';

import 'package:blade/blade_container.dart';
import 'package:blade/messages.dart';
import 'package:blade/logger.dart';
import 'package:blade/blade_navigator.dart';
import 'package:blade/page_visibility.dart';
import 'package:blade/overlay_entry.dart';
import 'package:blade/messenger/page_info.dart';

import 'blade_page.dart';

typedef BladeAppBuilder = Widget Function(Widget home);

typedef PageBuilder = Widget Function(
    BuildContext context, RouteSettings settings);

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

class BladeAppState extends State<BladeApp> implements PageEventListener {
  final Map<String, Completer<Object>> _pendingResult = <String, Completer<Object>>{};

  List<BladeContainer> get containers => _containers;
  final List<BladeContainer> _containers = <BladeContainer>[];
  BladeContainer get topContainer => containers.last;

  final List<BladeContainer> _pendingPopcontainers = <BladeContainer>[];

  NativeRouterApi get nativeRouterApi => _nativeRouterApi;
  late NativeRouterApi _nativeRouterApi;

  late EventDispatcher  eventDispatcher;


  BladeRouteFactory get routeFactory => widget.routeFactory;
  final Set<int> _activePointers = <int>{};

  @override
  void initState() {
    final pageName = widget.initialRoute;

    _containers.add(_createContainer(
        PageInfo(name: pageName, id: _createUniqueId(pageName))));

    _nativeRouterApi = NativeRouterApi();


    eventDispatcher = EventDispatcher(this);

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
      for (BladeContainer container in containers) {
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

  String _createUniqueId(String pageName) {
    if (kReleaseMode) {
      return Uuid().v4();
    } else {
      return Uuid().v4() + '#$pageName';
    }
  }

  BladeContainer _createContainer(PageInfo pageInfo) {
    return BladeContainer(
        key: ValueKey<String>(pageInfo.id),
        pageInfo: pageInfo,
        routeFactory: widget.routeFactory);
  }

  Future<T> pushWithResult<T extends Object>(String pageName,
      {Map<String, Object>? arguments, bool withContainer = true}) {
    String uniqueId = _createUniqueId(pageName);
    if (withContainer) {
      final CommonParams params = CommonParams()
        ..pageName = pageName
        ..uniqueId = uniqueId
        ..arguments = arguments;
      nativeRouterApi.pushFlutterRoute(params);
    } else {
      push(pageName,
          uniqueId: uniqueId, arguments: arguments, withContainer: false);
    }

    final Completer<T> completer = Completer<T>();
    _pendingResult[uniqueId] = completer;
    return completer.future;
  }

  void push(String pageName,
      {required String uniqueId,
      Map<String, dynamic>? arguments,
      bool withContainer = true}) {
    _cancelActivePointers();
    final BladeContainer? container = _findContainerByUniqueId(uniqueId);
    if (container != null) {
      if (topContainer != container) {
        PageVisibilityBinding.instance
            .dispatchPageHideEvent(_getCurrentPageRoute());
        containers.remove(container);
        container.detach();
        containers.add(container);
        insertEntry(container);
        PageVisibilityBinding.instance
            .dispatchPageShowEvent(container.topPage.route);
      } else {
        PageVisibilityBinding.instance
            .dispatchPageShowEvent(_getCurrentPageRoute());
      }
    } else {
      final PageInfo pageInfo = PageInfo(
          name: pageName,
          id: uniqueId,
          arguments: arguments,
          withContainer: withContainer);
      if (withContainer) {
        PageVisibilityBinding.instance
            .dispatchPageHideEvent(_getCurrentPageRoute());

        final container = _createContainer(pageInfo);
        containers.add(container);
        insertEntry(container);
      } else {
        final page = BladePage.create(pageInfo, topContainer.routeFactory);
        topContainer.push(page);
      }
    }
    Logger.log(
        'push page, uniqueId=$uniqueId, existed=$container, withContainer=$withContainer, arguments:$arguments, $containers');
  }

  Future<void> popWithResult<T extends Object>(T? result) async {
    final String uniqueId = topContainer.topPage.pageInfo.id;
    final result = pop(uniqueId: uniqueId);
    if (result == true) {
      if (_pendingResult.containsKey(uniqueId)) {
        _pendingResult[uniqueId]?.complete(result);
        _pendingResult.remove(uniqueId);
      }
    }
  }

  Future<bool> popUntil(String uniqueId,
      {Map<dynamic, dynamic>? arguments}) async {
    final BladeContainer? container = _findContainerByUniqueId(uniqueId);
    if (container == null) {
      Logger.error('uniqueId=$uniqueId not find');
      return false;
    }
    final BladePage? page = _findPageByUniqueId(uniqueId, container);
    if (page == null) {
      Logger.error('uniqueId=$uniqueId page not find');
      return false;
    }

    if (container != topContainer) {
      final CommonParams params = CommonParams()
        ..pageName = container.pageInfo.name
        ..uniqueId = container.pageInfo.id
        ..arguments = container.pageInfo.arguments;
      await _nativeRouterApi.popUtilRouter(params);
    }
    container.popUntil(page.pageInfo.name);
    Logger.log(
        'pop container, uniqueId=$uniqueId, arguments:$arguments, $container');
    return true;
  }

  bool pop({String? uniqueId, Map<dynamic, dynamic>? arguments}) {
    BladeContainer? container;
    if (uniqueId != null) {
      container = _findContainerByUniqueId(uniqueId);
      if (container == null) {
        Logger.error('uniqueId=$uniqueId not find');
        return false;
      }
    } else {
      container = topContainer;
    }

    if (container != topContainer) {
      return false;
    }
    if (container.pages.length > 1) {
      container.pop();
    } else {
      _notifyNativePop(container);
    }

    Logger.log(
        'pop container, uniqueId=$uniqueId, arguments:$arguments, $container');
    return true;
  }

  void enablePanGesture(String uniqueId, bool enable) {
    final PanGestureParams params = PanGestureParams()
      ..uniqueId = uniqueId
      ..enable = enable;
    nativeRouterApi.enablePanGesture(params);
  }

  void _notifyNativePop(BladeContainer container) async {
    Logger.log('_removeContainer ,  uniqueId=${container.pageInfo.id}');
    _containers.remove(container);
    _pendingPopcontainers.add(container);
    final CommonParams params = CommonParams()
      ..pageName = container.pageInfo.name
      ..uniqueId = container.pageInfo.id
      ..arguments = container.pageInfo.arguments;
    await _nativeRouterApi.popRoute(params);

    if (Platform.isAndroid) {
      _removeContainer(container.pageInfo.id,
          targetContainers: _pendingPopcontainers);
    }
  }


  void _removeContainer(String uniqueId,
      {required List<BladeContainer> targetContainers}) {
    BladeContainer? container = _findContainer(targetContainers, uniqueId);
    if (container != null) {
      targetContainers.remove(container);
      detachContainer(container);
    }
  }

  Route<dynamic>? _getCurrentPageRoute() {
    return topContainer.topPage.route;
  }

  String _getCurrentPageUniqueId() {
    return topContainer.topPage.pageInfo.id;
  }

  String? _getPreviousPageUniqueId() {
    assert(topContainer.pages != null);
    final int pageCount = topContainer.pages.length;
    if (pageCount > 1) {
      return topContainer.pages[pageCount - 2].pageInfo.id;
    } else {
      final int containerCount = containers.length;
      if (containerCount > 1) {
        return containers[containerCount - 2].pages.last.pageInfo.id;
      }
    }

    return null;
  }

  Route<dynamic>? _getPreviousPageRoute() {
    final int pageCount = topContainer.pages.length;
    if (pageCount > 1) {
      return topContainer.pages[pageCount - 2].route;
    } else {
      final int containerCount = containers.length;
      if (containerCount > 1) {
        return containers[containerCount - 2].pages.last.route;
      }
    }

    return null;
  }

  BladeContainer? _findContainerByUniqueId(String uniqueId) {
    return _findContainer(_containers, uniqueId);
  }

  BladeContainer? _findContainer(
      List<BladeContainer> containers, String uniqueId) {
    try {
      return containers.singleWhere((BladeContainer element) =>
          (element.pageInfo.id == uniqueId) ||
          element.pages.any((BladePage<dynamic> element) =>
              element.pageInfo.id == uniqueId));
    } catch (e) {
      Logger.logObject(e);
    }
    return null;
  }

  BladePage? _findPageByUniqueId(String uniqueId, BladeContainer container) {
    try {
      return container.pages.singleWhere(
          (BladePage element) => element.pageInfo.id == uniqueId);
    } catch (e) {
      Logger.logObject(e);
    }
    return null;
  }

  void detachContainer(BladeContainer container) {
    Route<dynamic>? route = container.pages.first.route;
    PageVisibilityBinding.instance.dispatchPageDestoryEvent(route);
    container.detach();
  }

  PageInfo getTopPageInfo() {
    return topContainer.topPage.pageInfo;
  }

  int pageSize() {
    int count = 0;
    for (BladeContainer container in containers) {
      count += container.size;
    }
    return count;
  }


  // PageEventListener
  void pushPage(PageInfo pageInfo) {
    push(pageInfo.name, uniqueId: pageInfo.id, arguments: pageInfo.arguments, withContainer: true);
  }

  void popPage(PageInfo pageInfo) {

  }

  void removePage(PageInfo pageInfo) {
    _removeContainer(pageInfo.id, targetContainers: _pendingPopcontainers);
    _removeContainer(pageInfo.id, targetContainers: _containers);
  }

  void onPageAppeared(PageInfo pageInfo) {
    PageVisibilityBinding.instance
        .dispatchPageShowEvent(_getCurrentPageRoute());
  }

  void onPageDisappeared(PageInfo pageInfo) {
    if (topContainer.pageInfo.id != pageInfo.id) {
      return;
    }

    PageVisibilityBinding.instance
        .dispatchPageHideEvent(_getCurrentPageRoute());

  }

  void onForeground() {
    PageVisibilityBinding.instance
        .dispatchForegroundEvent(_getCurrentPageRoute());
  }

  void onBackground() {
    PageVisibilityBinding.instance
        .dispatchBackgroundEvent(_getCurrentPageRoute());
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
        BladeNavigator.of().enablePanGesture(_uniqueId, false);
        canDisable = false;
      }
    }
  }

  void _enablePanGesture() {
    if (Platform.isIOS) {
      if (_pageList.length == 1) {
        BladeNavigator.of().enablePanGesture(_uniqueId, true);
        canDisable = true;
      }
    }
  }
}
