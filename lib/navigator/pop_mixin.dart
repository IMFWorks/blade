import 'package:blade/container/blade_container.dart';
import 'package:blade/container/blade_page.dart';
import 'package:blade/messenger/nativeEvents/pop_native_page_event.dart';
import 'package:blade/messenger/nativeEvents/pop_until_native_page_event.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:blade/navigator/base_navigator.dart';
import '../logger.dart';

mixin PopMixin on BaseNavigator {
  final List<BladeContainer> _pendingPopContainers = <BladeContainer>[];

  void pop<T>({T? result}) async {
    final container = topContainer;
    if (container.pages.length > 1) {
      container.pop(result);
    } else {
      _popContainer(container, result as Map<String, dynamic>?);
    }

    Logger.log('pop , $container');
  }

  void popUtil(String name) async {
    final container = containerManager.getContainerByName(name);
    if(container != null) {
      if (container != topContainer) {
        // pop 依赖name去查找对应的Container，id默认给''
        final pageInfo = PageInfo(name: name, id: "");
        final event = PopUntilNativePageEvent(pageInfo);
        eventDispatcher.sendNativeEvent(event);
      }

      container.popUntil(name);
    } else {
      Logger.error("popUtil id not found");
    }
  }

  void _popContainer(BladeContainer container, Map<String, dynamic>? result) async {
    Logger.log('_popContainer ,  id=${container.pageInfo.id}');
    containerManager.removeContainer(container);
    _pendingPopContainers.add(container);

    final pageInfo = PageInfo(name: container.pageInfo.name,
        id: container.pageInfo.id,
        arguments:result);
    final popNativePageEvent = PopNativePageEvent(pageInfo);
    eventDispatcher.sendNativeEvent(popNativePageEvent);
  }

  void removeContainer(PageInfo pageInfo) {
    _removeContainer(pageInfo.id, targetContainers: _pendingPopContainers);
    _removeContainer(pageInfo.id, targetContainers: containerManager.containers);
  }

  void removePendingContainerById(String id) {
    _removeContainer(id, targetContainers: _pendingPopContainers);
  }

  void _removeContainer(String id, {required List<BladeContainer> targetContainers}) {
    BladeContainer? removedContainer;
    targetContainers.removeWhere((element) {
      final isSame = element.pageInfo.id == id;
      if (isSame) {
        removedContainer = element;
      }

      return isSame;
    } );

    removedContainer?.entryRemoved();
  }

  BladeContainer? getPendingPopContainer(String id) {
    try {
      return _pendingPopContainers.singleWhere((BladeContainer element) =>
      (element.pageInfo.id == id) ||
          element.pages.any((BladePage<dynamic> element) =>
          element.pageInfo.id == id));
    } catch (e) {
      Logger.logObject(e);
    }
    return null;
  }
}