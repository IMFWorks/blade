import 'json_convertible.dart';

class NativeEvent implements JsonConvertible{
  String method;
  JsonConvertible payload;

  NativeEvent(this.method, this.payload);

  Map<String, dynamic> toJson() {
    return payload.toJson();
  }
}