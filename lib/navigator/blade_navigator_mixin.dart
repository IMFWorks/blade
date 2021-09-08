import 'package:blade/container/blade_page.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:blade/navigator/base_navigator.dart';
import 'package:blade/messenger/nativeEvents/push_flutter_page_event.dart';
import 'package:blade/messenger/nativeEvents/push_native_page_event.dart';
import 'package:blade/navigator/pop_mixin.dart';
import '../blade_navigator.dart';

mixin BladeNavigatorMixin on BaseNavigator, PopMixin implements BladeNavigator {
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

//


// void enablePanGesture(String uniqueId, bool enable) {
//   final PanGestureParams params = PanGestureParams()
//     ..uniqueId = uniqueId
//     ..enable = enable;
//   nativeRouterApi.enablePanGesture(params);
// }

}