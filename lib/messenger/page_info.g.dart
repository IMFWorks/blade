// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) {
  return PageInfo(
    name: json['name'] as String,
    id: json['id'] as String,
    arguments: json['arguments'] as Map<String, dynamic>?
  );
}

Map<String, dynamic> _$PageInfoToJson(PageInfo instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'arguments': instance.arguments,
};
