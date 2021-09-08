import 'dart:io';

import 'package:blade/container/blade_container.dart';
import 'package:blade/container/page_lifecycle.dart';
import 'package:blade/messenger/event_dispatcher.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:blade/navigator/base_navigator.dart';
import 'package:blade/navigator/pop_mixin.dart';
import 'package:blade/navigator/push_mixin.dart';

mixin PlatformEventHandler on BaseNavigator, PushMixin, PopMixin implements PageEventListener {

  void init() {
    super.init();

    eventDispatcher.pageEventListener = this;
  }

  // PageEventListener
  void pushPage(PageInfo pageInfo) {
    push(pageInfo);
  }

  void popPage(PageInfo pageInfo) {
    pop(id: pageInfo.id);
  }

  void removePage(PageInfo pageInfo) {
    removeContainer(pageInfo);
  }

  void onPageAppeared(PageInfo pageInfo) {
    final container = containerManager.getContainerById(pageInfo.id);
    if (container != null) {
      final route = container.getPageById(pageInfo.id)?.route;
      if (route != null) {
        PageLifecycle.shared.dispatchAppearedEvent(route);
      }
    }
  }

  void onPageDisappeared(PageInfo pageInfo) {
    final container = containerManager.getContainerById(pageInfo.id);
    if (container != null) {
      dispatchDisappearedEvent(container);
    } else {
      // 因pop导致的Disappeared
      final container = getPendingPopContainer(pageInfo.id);
      if (container != null) {
        dispatchDisappearedEvent(container);
      }

      if (Platform.isAndroid) {
        removePendingContainerById(pageInfo.id);
      }
    }
  }

  void dispatchDisappearedEvent(BladeContainer container) {
    final topRoute = container.topRoute;
    if (topRoute != null) {
      PageLifecycle.shared.dispatchDisappearedEvent(topRoute);
    }
  }

  void onForeground() {
    final topRoute = topContainer.topRoute;
    if (topRoute != null) {
      PageLifecycle.shared.dispatchForegroundEvent(topRoute);
    }
  }

  void onBackground() {
    final topRoute = topContainer.topRoute;
    if (topRoute != null) {
      PageLifecycle.shared.dispatchBackgroundEvent(topRoute);
    }
  }
}

