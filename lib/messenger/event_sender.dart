
import 'package:blade/messenger/NativeEvents/base/native_event.dart';

mixin EventSender {
  Future<T?> sendNativeEvent<T>(NativeEvent event);
}