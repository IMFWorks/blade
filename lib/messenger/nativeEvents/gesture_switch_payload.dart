import 'package:blade/messenger/NativeEvents/base/json_convertible.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gesture_switch_payload.g.dart';

@JsonSerializable()
class GestureSwitchPayload extends JsonConvertible {
  GestureSwitchPayload(this.id, this.enable);
  String id;
  final bool enable;

  Map<String, dynamic> toJson() {
    return _$GestureSwitchPayloadToJson(this);
  }
}