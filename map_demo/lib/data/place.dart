import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'place.g.dart';

@JsonSerializable()
class Place {
  String? id;
  String? text;
  String? place_name;
  List<double>? center;

  Place({
    this.id,
    this.text,
    this.place_name,
    this.center,
  });

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}
