import 'package:blade/messenger/NativeEvents/base/native_event.dart';
import 'package:blade/messenger/nativeEvents/gesture_switch_payload.dart';

class GestureSwitchEvent extends NativeEvent {
  GestureSwitchEvent(GestureSwitchPayload payload): super('gestureSwitch', payload);
}