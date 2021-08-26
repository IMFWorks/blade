import 'dart:async';

import 'package:blade/messenger/page_info.dart';
import 'package:flutter/cupertino.dart';
import '../logger.dart';
import 'blade_page.dart';

class BladeContainer extends ChangeNotifier {
  final BladeRouteFactory routeFactory;
  final PageInfo pageInfo;
  final List<BladePage<dynamic>> _pages = <BladePage<dynamic>>[];

  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  List<BladePage<dynamic>> get pages {
    return List.unmodifiable(_pages);
  }

  @override
  void dispose() {
    super.dispose();

    entryRemoved();
  }

  Route<dynamic>? get topRoute {
    if (_pages.length > 0) {
      return _pages.last.route;
    } else {
      return null;
    }
  }

  BladeContainer(this.routeFactory, this.pageInfo) {
    final initialPage = BladePage(routeFactory: routeFactory, pageInfo: pageInfo);
    _pages.add(initialPage);
  }

  bool canPop() {
    return _pages.length > 1;
  }

  Future<T?> push<T extends Object?>(BladePage<T> page) {
    _pages.add(page);
    notifyListeners();
    return page.popped;
  }

  void pop<T extends Object?>([T? result ])  {
    if (_pages.length > 0) {
      final poppedPage = _pages.last;
      popPage(poppedPage,result);
    }
  }

  void popPage<T extends Object?>(BladePage<T> page, [T? result ])  {
    _pages.remove(page);
    page.didComplete(result);
    notifyListeners();
  }

  void popUntil(String pageName) {
     //
  }

  VoidCallback? entryRemovedCallback;

  void entryRemoved() {
    final tempEntryRemovedCallback = entryRemovedCallback;
    if (tempEntryRemovedCallback != null) {
      tempEntryRemovedCallback();
    }

    entryRemovedCallback = null;

    // Ensure this frame is refreshed after schedule frame，otherwise the PageState.dispose may not be called
    // final instance = SchedulerBinding.instance;
    // if (instance != null) {
    //   final bool hasScheduledFrame = instance.hasScheduledFrame;
    //   final bool framesEnabled = instance.framesEnabled;
    //
    //   if (hasScheduledFrame || !framesEnabled) {
    //     instance.scheduleWarmUpFrame();
    //   }
    // }
  }

  BladePage? getPageById(String id) {
    try {
      return _pages.singleWhere((BladePage element) => element.pageInfo.id == id);
    } catch (e) {
      Logger.logObject(e);
    }

    return null;
  }
}