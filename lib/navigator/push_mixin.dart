import 'package:blade/container/blade_container.dart';
import 'package:blade/container/blade_page.dart';
import 'package:blade/messenger/nativeEvents/push_flutter_page_event.dart';
import 'package:blade/messenger/nativeEvents/push_native_page_event.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:blade/navigator/base_navigator.dart';

import '../logger.dart';

mixin PushMixin on BaseNavigator {

  void push(PageInfo pageInfo) {
    final id = pageInfo.id;
    final BladeContainer? container = containerManager.getContainerById(id);
    if (container != null) {
      if (topContainer != container) {
        containerManager.removeContainer(container);
        rawStack.remove(container);
        containerManager.addContainer(container);
        rawStack.push(container);
      } else {
      }
    } else {
      final container = containerManager.createContainer(pageInfo);
      containerManager.addContainer(container);
      rawStack.push(container);
    }

    Logger.log('push page,'
        ' id=$id, '
        'existed=$container,'
        'arguments:$pageInfo.arguments');
  }

  /// Push native page onto the hybrid stack.
  Future<T?> pushNativePage<T extends Object>(String name,
      {Map<String, Object>? arguments}) async {
    String id = createPageId(name);
    final pageInfo = PageInfo(name: name, id: id, arguments:  arguments);
    final event = PushNativePageEvent(pageInfo);
    return eventDispatcher.sendNativeEvent(event);
  }

  Future<T?> pushFlutterPageOnNative<T>(String name,
      {Map<String, Object>? arguments}) async {
    String id = createPageId(name);
    final pageInfo = PageInfo(name: name, id: id, arguments:  arguments);
    final event = PushFlutterPageEvent(pageInfo);
    return eventDispatcher.sendNativeEvent(event);
  }

  Future<T?> pushFlutterPage<T>(String name,
      {Map<String, Object>? arguments}) async {
    String id = createPageId(name);
    final pageInfo = PageInfo(name: name, id: id, arguments:  arguments);
    final page = BladePage.create<T>(pageInfo, topContainer.routeFactory);
    return topContainer.push(page);
  }
}