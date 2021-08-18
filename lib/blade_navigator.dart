import 'dart:async';
import 'dart:io';

import 'package:blade/container/container_manager.dart';
import 'package:blade/messenger/nativeEvents/push_flutter_page_event.dart';
import 'package:blade/messenger/nativeEvents/push_native_page_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'blade_app.dart';
import 'container/blade_container.dart';
import 'container/blade_page.dart';
import 'container/overlay_entry.dart';
import 'logger.dart';
import 'messenger/event_dispatcher.dart';
import 'messenger/nativeEvents/pop_native_page_event.dart';
import 'messenger/page_info.dart';

mixin BladeNavigator {
  ContainerManager get containerManager;
  EventSender get eventSender;
  BladeContainer get topContainer {
    return containerManager.topContainer;
  }

  final List<BladeContainer> _pendingPopContainers = <BladeContainer>[];

  void initBladeNavigator(String initialRoute) {
    final name = initialRoute;
    final pageInfo = PageInfo(name: name, id: _createPageId(name));
    final initialContainer = containerManager.createContainer(pageInfo);
    containerManager.addContainer(initialContainer);
  }

  static BladeNavigator of() {
    BuildContext? context = overlayKey.currentContext;
    if (context != null) {
      BladeAppState? appState;
      appState = context.findAncestorStateOfType<BladeAppState>();
      if (appState != null) {
        return appState;
      } else {
        throw Exception('appState is null');
      }
    } else {
      throw Exception('overlayKey.currentContext is null');
    }
  }

  /// Push native page onto the hybrid stack.
  Future<T?> pushNativePage<T extends Object>(String name,
      {Map<String, Object>? arguments}) async {
    String id = _createPageId(name);
    final pageInfo = PageInfo(name: name, id: id, arguments:  arguments);
    final event = PushNativePageEvent(pageInfo);
    return eventSender.sendNativeEvent(event);
  }

  Future<T?> pushFlutterPageOnNative<T>(String name,
      {Map<String, Object>? arguments
      }) {
    String id = _createPageId(name);
    final pageInfo = PageInfo(name: name, id: id, arguments:  arguments);
    final pushFlutterPageEvent = PushFlutterPageEvent(pageInfo);
    return eventSender.sendNativeEvent(pushFlutterPageEvent);
  }

  Future<T?> pushFlutterPage<T>(String name,
      {Map<String, Object>? arguments}) {
    String id = _createPageId(name);
    final pageInfo = PageInfo(name: name, id: id, arguments:  arguments);
    final page = BladePage.create<T>(pageInfo, topContainer.routeFactory);
    return topContainer.push(page);
  }

  /// Push flutter page onto the hybrid stack.
  void push<T>(PageInfo pageInfo) {
    final id = pageInfo.id;
    final BladeContainer? container = containerManager.getContainerById(id);
    if (container != null) {
      if (topContainer != container) {
        // PageVisibilityBinding.instance
        //     .dispatchPageHideEvent(_getCurrentPageRoute());

        containerManager.removeContainer(container);
        container.detach();
        containerManager.addContainer(container);
        insertEntry(container);
        // PageVisibilityBinding.instance
        //     .dispatchPageShowEvent(container.topPage.route);
      } else {
        // PageVisibilityBinding.instance
        //     .dispatchPageShowEvent(_getCurrentPageRoute());
      }
    } else {
      final container = containerManager.createContainer(pageInfo);
      containerManager.addContainer(container);
      insertEntry(container);
    }

    Logger.log('push page,'
            ' id=$id, '
            'existed=$container,'
            ' withContainer=$pageInfo.withContainer, '
            'arguments:$pageInfo.arguments');
  }

  void pop<T>({String? id, T? result}) async {
    BladeContainer? container;
    if (id != null) {
      container = containerManager.getContainerById(id);
      if (container == null) {
        return;
      }
    } else {
      container = topContainer;
    }

    if (container != topContainer) {
      return;
    }
    if (container.pages.length > 1) {
      container.pop(result);
    } else {
      _popContainer(container, result as Map<String, dynamic>?);
    }

    Logger.log('pop , id=$id, $container');
  }

  Future<void> popUtil<T extends Object>(String id, [T? result]) async {
  }

  //
  // Future<bool> popUntil(String uniqueId,
  //     {Map<dynamic, dynamic>? arguments}) async {
  //   final BladeContainer? container = _findContainerByUniqueId(uniqueId);
  //   if (container == null) {
  //     Logger.error('uniqueId=$uniqueId not find');
  //     return false;
  //   }
  //   final BladePage? page = _findPageByUniqueId(uniqueId, container);
  //   if (page == null) {
  //     Logger.error('uniqueId=$uniqueId page not find');
  //     return false;
  //   }
  //
  //   if (container != topContainer) {
  //     final CommonParams params = CommonParams()
  //       ..pageName = container.pageInfo.name
  //       ..uniqueId = container.pageInfo.id
  //       ..arguments = container.pageInfo.arguments;
  //     await _nativeRouterApi.popUtilRouter(params);
  //   }
  //   container.popUntil(page.pageInfo.name);
  //   Logger.log(
  //       'pop container, uniqueId=$uniqueId, arguments:$arguments, $container');
  //   return true;
  // }
  //


  // void enablePanGesture(String uniqueId, bool enable) {
  //   final PanGestureParams params = PanGestureParams()
  //     ..uniqueId = uniqueId
  //     ..enable = enable;
  //   nativeRouterApi.enablePanGesture(params);
  // }

  void _popContainer(BladeContainer container, Map<String, dynamic>? result) async {
    Logger.log('_removeContainer ,  uniqueId=${container.pageInfo.id}');
    containerManager.removeContainer(container);
    _pendingPopContainers.add(container);


    final pageInfo = PageInfo(name: container.pageInfo.name,
        id: container.pageInfo.id,
        arguments:result);
    final popNativePageEvent = PopNativePageEvent(pageInfo);
    eventSender.sendNativeEvent(popNativePageEvent);

    if (Platform.isAndroid) {
      _removeContainer(container.pageInfo.id,
          targetContainers: _pendingPopContainers);
    }
  }

  void _removeContainer(String id, {required List<BladeContainer> targetContainers}) {
    final removedContainer = containerManager.removeContainerById(
        id, targetContainers);
    removedContainer?.detach();
  }


  // Route<dynamic>? _getCurrentPageRoute() {
  //   return topContainer.topPage.route;
  // }
  //
  // String _getCurrentPageUniqueId() {
  //   return topContainer.topPage.pageInfo.id;
  // }
  //
  // String? _getPreviousPageUniqueId() {
  //   assert(topContainer.pages != null);
  //   final int pageCount = topContainer.pages.length;
  //   if (pageCount > 1) {
  //     return topContainer.pages[pageCount - 2].pageInfo.id;
  //   } else {
  //     final int containerCount = containers.length;
  //     if (containerCount > 1) {
  //       return containers[containerCount - 2].pages.last.pageInfo.id;
  //     }
  //   }
  //
  //   return null;
  // }
  //
  // Route<dynamic>? _getPreviousPageRoute() {
  //   final int pageCount = topContainer.pages.length;
  //   if (pageCount > 1) {
  //     return topContainer.pages[pageCount - 2].route;
  //   } else {
  //     final int containerCount = containers.length;
  //     if (containerCount > 1) {
  //       return containers[containerCount - 2].pages.last.route;
  //     }
  //   }
  //
  //   return null;
  // }

  PageInfo getTopPageInfo() {
    return topContainer.topPage.pageInfo;
  }

  String _createPageId(String pageName) {
    return Uuid().v4() + '#$pageName';
  }
}