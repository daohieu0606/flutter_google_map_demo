// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      id: json['id'] as String?,
      text: json['text'] as String?,
      place_name: json['place_name'] as String?,
      center: (json['center'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'place_name': instance.place_name,
      'center': instance.center,
    };
