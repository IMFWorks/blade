import 'package:flutter/widgets.dart';

import 'package:blade/blade_app.dart';
import 'package:blade/messages.dart';
import 'package:blade/overlay_entry.dart';

import 'blade_container.dart';
import 'logger.dart';

/// A object that manages a set of pages with a hybrid stack.
///
class BladeNavigator {
  const BladeNavigator(this._appState);

  final BladeAppState _appState;

  /// Retrieves the instance of [BladeNavigator]
  static BladeNavigator of() {
    BuildContext? context = overlayKey.currentContext;
    if (context != null) {
      BladeAppState? appState;
      appState = context.findAncestorStateOfType<BladeAppState>();
      if (appState != null) {
        return BladeNavigator(appState);
      } else {
        throw Exception('appState is null');
      }
    } else {
      throw Exception('overlayKey.currentContext is null');
    }
  }

  String? getUniqueIdFromName(String pageName) {
    try {
      return _appState.containers
          .firstWhere((element) =>
              element.pageInfo.pageName == pageName ||
              element.pages
                  .any((element) => element.pageInfo.pageName == pageName))
          .pageInfo
          .uniqueId;
    } catch (e) {
      Logger.logObject(e);
    }
    return null;
  }

  /// Whether this page with the given [name] is a flutter page
  ///
  /// If the name of route can be found in route table then return true,
  /// otherwise return false.
  bool isFlutterPage(String name) {
    return _appState.routeFactory(RouteSettings(name: name), "") != null;
  }

  /// Push the page with the given [name] onto the hybrid stack.
  Future<T?> push<T extends Object>(String name,
      {Map<Object, Object>? arguments, bool withContainer = true}) {
    if (isFlutterPage(name)) {
      return _appState.pushWithResult(name,
          arguments: arguments, withContainer: withContainer);
    } else {
      final CommonParams params = CommonParams()
        ..pageName = name
        ..arguments = arguments;
      _appState.nativeRouterApi.pushNativeRoute(params);
      return Future<T?>(() => null);
    }
  }

  Future<T> pushWithResult<T extends Object>(String pageName,
      {Map<Object, Object>? arguments, bool withContainer = true}) {
    return _appState.pushWithResult(pageName,
        arguments: arguments, withContainer: withContainer);
  }

  Future<void> pushNativeRoute(CommonParams arg) {
    return _appState.nativeRouterApi.pushNativeRoute(arg);
  }

  void enablePanGesture(String uniqueId, bool enable) {
    return _appState.enablePanGesture(uniqueId, enable);
  }

  /// Pop the top-most page off the hybrid stack.
  Future<void> pop<T extends Object>([T? result]) async {
    return _appState.popWithResult(result);
  }

  Future<void> popUtil<T extends Object>(String uniqueId, [T? result]) async {
    await _appState.popUntil(uniqueId);
  }

  /// Remove the page with the given [uniqueId] from hybrid stack.
  ///
  /// This API is for backwards compatibility.
  void remove(String uniqueId) {
    _appState.pop(uniqueId: uniqueId);
  }

  /// Retrieves the infomation of the top-most flutter page
  /// on the hybrid stack, such as uniqueId, pagename, etc;
  ///
  /// This is a legacy API for backwards compatibility.
  PageInfo getTopPageInfo() {
    return _appState.getTopPageInfo();
  }

  PageInfo? getTopByContext(BuildContext context) {
    return BladeContainer.of(context)?.pageInfo;
  }

  /// Return the number of flutter pages
  ///
  /// This is a legacy API for backwards compatibility.
  int pageSize() {
    return _appState.pageSize();
  }
}

class PageInfo {
  PageInfo(
      {required this.pageName,
      required this.uniqueId,
      this.arguments,
      this.withContainer = true});

  bool withContainer;
  String pageName;
  String uniqueId;
  Map<dynamic, dynamic>? arguments;
}
