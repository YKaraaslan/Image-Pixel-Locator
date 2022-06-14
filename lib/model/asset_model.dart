import 'dart:convert';

class AssetModel {
  String? name;
  String? description;
  int? counter;
  Coordinates? coordinates;

  AssetModel({
    this.name,
    this.description,
    this.counter,
    this.coordinates,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'counter': counter,
      'coordinates': coordinates?.toMap(),
    };
  }

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      name: map['name'],
      description: map['description'],
      counter: map['counter']?.toInt(),
      coordinates: map['coordinates'] != null ? Coordinates.fromMap(map['coordinates']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetModel.fromJson(String source) => AssetModel.fromMap(json.decode(source));
}

class Coordinates {
  double? x;
  double? y;

  Coordinates({
    this.x,
    this.y,
  });

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
    };
  }

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      x: map['x']?.toDouble(),
      y: map['y']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Coordinates.fromJson(String source) => Coordinates.fromMap(json.decode(source));
}
