import 'package:json_annotation/json_annotation.dart';

part 'FlutterEventResponse.g.dart';

@JsonSerializable()
class FlutterEventResponse {
  final int status;

  FlutterEventResponse(this.status);

  factory FlutterEventResponse.fromJson(Map<String, dynamic> json) => _$FlutterEventResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FlutterEventResponseToJson(this);
}

class Status {
  static const int ok = 200;
  static const int noContent = 204;
  static const int notFound = 404;
}


