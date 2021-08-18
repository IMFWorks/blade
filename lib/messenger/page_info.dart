import 'package:blade/messenger/NativeEvents/json_convertible.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page_info.g.dart';

@JsonSerializable()
class PageInfo implements JsonConvertible{
  PageInfo({required this.name,
        required this.id,
        this.arguments}) ;

  String name;
  String id;
  Map<String, dynamic>? arguments;

  factory PageInfo.fromJson(Map<String, dynamic> json) => _$PageInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PageInfoToJson(this);
}