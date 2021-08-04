import 'package:blade/blade_app.dart';
import 'package:blade/messages.dart';

/// The MessageChannel counterpart on the Dart side.
class BladeFlutterRouterApi extends FlutterRouterApi {
  
  factory BladeFlutterRouterApi(BladeAppState appState) {
    BladeFlutterRouterApi? instance = _instance;
    if (instance == null) {
      instance = BladeFlutterRouterApi._(appState);
      _instance = instance;
      FlutterRouterApi.setup(instance);
    }
    return instance;
  }

  BladeFlutterRouterApi._(this.appState);

  final BladeAppState appState;
  static BladeFlutterRouterApi? _instance = null;

  @override
  void pushRoute(CommonParams arg) {
    final pageName = arg.pageName;
    final uniqueId = arg.uniqueId;
    if (pageName != null && uniqueId != null) {
      appState.push(pageName,
          uniqueId: uniqueId, arguments: arg.arguments, withContainer: true);
    }
  }

  @override
  void popRoute(CommonParams arg) {
    appState.pop(uniqueId: arg.uniqueId);
  }

  @override
  void onForeground(CommonParams arg) {
    appState.onForeground();
  }

  @override
  void onBackground(CommonParams arg) {
    appState.onBackground();
  }

  @override
  void onNativeViewShow(CommonParams arg) {
    appState.onNativeViewShow(arg: arg);
  }

  @override
  void onNativeViewHide(CommonParams arg) {
    appState.onNativeViewHide(arg: arg);
  }

  @override
  void removeRoute(CommonParams arg) {
    appState.removeRouter(arg.uniqueId);
  }
}
