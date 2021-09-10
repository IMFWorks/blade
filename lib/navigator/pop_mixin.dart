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

  void popUtil<T extends Object>(String name) async {
    final container = containerManager.getContainerByName(name);
    if(container != null) {
      if (container == topContainer) {
        if (container.pageInfo.name == name) {
          _popContainer(container, null);
        } else {
          container.popUntil(name);
        }
      } else {
        final pageInfo = PageInfo(name: name,
            id: "",
            arguments: null);
        final event = PopUntilNativePageEvent(pageInfo);
        eventDispatcher.sendNativeEvent(event);
      }
    } else {
      Logger.error("popUtil id not found");
    }
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