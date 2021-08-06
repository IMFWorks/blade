import 'package:json_annotation/json_annotation.dart';


part 'FlutterEventResponse.g.dart';

@JsonSerializable()
class FlutterEventResponse {
  final int status;

  FlutterEventResponse({required this.status});

  factory FlutterEventResponse.fromJson(Map<String, dynamic> json) => _$FlutterEventResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FlutterEventResponseToJson(this);

}


