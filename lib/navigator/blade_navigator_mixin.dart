import 'package:blade/container/blade_page.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:blade/navigator/base_navigator.dart';
import 'package:blade/messenger/nativeEvents/push_flutter_page_event.dart';
import 'package:blade/messenger/nativeEvents/push_native_page_event.dart';
import 'package:blade/navigator/pop_mixin.dart';
import '../blade_navigator.dart';

mixin BladeNavigatorMixin on BaseNavigator, popMixin implements BladeNavigator {
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
    final pushFlutterPageEvent = PushFlutterPageEvent(pageInfo);
    return eventDispatcher.sendNativeEvent(pushFlutterPageEvent);
  }

  Future<T?> pushFlutterPage<T>(String name,
      {Map<String, Object>? arguments}) async {
    String id = createPageId(name);
    final pageInfo = PageInfo(name: name, id: id, arguments:  arguments);
    final page = BladePage.create<T>(pageInfo, topContainer.routeFactory);
    return topContainer.push(page);
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

// PageInfo getTopPageInfo() {
//   return topContainer.topPage.pageInfo;
// }
}