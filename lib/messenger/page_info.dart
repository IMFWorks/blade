import 'package:json_annotation/json_annotation.dart';

part 'page_info.g.dart';

@JsonSerializable()
class PageInfo {
  PageInfo({required this.name,
        required this.id,
        this.arguments,
        this.withContainer}) {
    if (withContainer == null) {
      withContainer = true;
    }
  }

  bool? withContainer;
  String name;
  String id;
  Map<String, dynamic>? arguments;

  factory PageInfo.fromJson(Map<String, dynamic> json) => _$PageInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PageInfoToJson(this);
}