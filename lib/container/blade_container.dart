import 'dart:async';
import 'dart:io';

import 'package:blade/messenger/event_sender.dart';
import 'package:blade/messenger/nativeEvents/gesture_switch_event.dart';
import 'package:blade/messenger/nativeEvents/gesture_switch_payload.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:flutter/cupertino.dart';
import '../logger.dart';
import 'blade_page.dart';

class BladeContainer extends ChangeNotifier {
  final BladeRouteFactory routeFactory;
  EventSender eventSender;
  final List<BladePage<dynamic>> _pages = <BladePage<dynamic>>[];
  List<BladePage<dynamic>> get pages {
    return _pages;
  }

  PageInfo get pageInfo {
    return _pages.first.pageInfo;
  }

  final navKey = GlobalKey<NavigatorState>();

  BladeContainer(this.routeFactory, PageInfo pageInfo, this.eventSender) {
    final initialPage = BladePage(routeFactory: routeFactory, pageInfo: pageInfo);
    _pages.add(initialPage);
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

  bool canPop() {
    return _pages.length > 1;
  }

  Future<T?> push<T extends Object?>(BladePage<T> page) {
    _pages.add(page);
    _handleGestureSwitch();
    notifyListeners();
    return page.popped;
  }

  void pop<T extends Object?>([T? result ]) {
    navKey.currentState?.maybePop(result);
  }

  void popPage<T extends Object?>(BladePage<T> page, [T? result ])  {
    _pages.remove(page);
    _handleGestureSwitch();
    page.didComplete(result);
    // notifyListeners();
  }

  void popUntil<T extends Object>(String name, [T? result]) {
    final page = getLatestPageByName(name);
    if (page != null) {
      navKey.currentState?.popUntil((route) => route.settings as BladePage == page);
      page.didComplete(result);
    }
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

  BladePage? getLatestPageById(String id) {
    try {
      return _pages.reversed.firstWhere((BladePage element) => element.pageInfo.id == id);
    } catch (e) {
      Logger.logObject(e);
    }

    return null;
  }

  BladePage? getLatestPageByName(String name) {
    try {
      return _pages.reversed.firstWhere((BladePage element) => element.pageInfo.name == name);
    } catch (e) {
      Logger.logObject(e);
    }

    return null;
  }

  void _handleGestureSwitch() {
    if (Platform.isIOS) {
      final bool enable =  _pages.length == 1;
      final payload = GestureSwitchPayload(pageInfo.id, enable);
      final event = GestureSwitchEvent(payload);
      eventSender.sendNativeEvent(event);
    }
  }
}