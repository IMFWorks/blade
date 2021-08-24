import 'package:blade/container/page_lifecycle.dart';
import 'package:blade/messenger/event_dispatcher.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:blade/navigator/base_navigator.dart';
import 'package:blade/navigator/pop_mixin.dart';
import 'package:blade/navigator/push_mixin.dart';
import 'package:flutter/cupertino.dart';

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
    remove(pageInfo);
  }

  void onPageAppeared(PageInfo pageInfo) {
    print('onPageAppeared');
    final container = containerManager.getContainerById(pageInfo.id);
    if (container != null) {
      final topRoute = container.topRoute;
      if (topRoute == null) {
        // 第一次页面还没初始化注册observer
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          final topRoute = container.topRoute;
          if (topRoute != null) {
            PageLifecycle.shared.dispatchAppearedEvent(topRoute);
          }
        });
      } else {
        PageLifecycle.shared.dispatchAppearedEvent(topRoute);
      }
    }
  }

  // todo-wrs 逻辑目前不正确
  void onPageDisappeared(PageInfo pageInfo) {
    // if (topContainer.pageInfo.id != pageInfo.id) {
    //   return;
    // }

    final id = topContainer.pageInfo.id;
    final container = containerManager.getContainerById(id);
    if (container != null) {
      final topRoute = container.topRoute;
      if (topRoute != null) {
        PageLifecycle.shared.dispatchDisappearedEvent(topRoute);
      }
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

