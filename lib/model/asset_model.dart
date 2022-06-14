import 'dart:convert';

class AssetModel {
  String? name;
  String? description;
  String? type;
  List<Machines?>? machines;

  AssetModel({
    this.name,
    this.description,
    this.type,
    this.machines,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'machines': machines?.map((x) => x?.toMap()).toList(),
    };
  }

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      name: map['name'],
      description: map['description'],
      type: map['type'],
      machines: map['machines'] != null ? List<Machines?>.from(map['machines']?.map((x) => Machines?.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetModel.fromJson(String source) => AssetModel.fromMap(json.decode(source));
}

class Machines {
  String? name;
  String? description;
  Coordinates? coordinates;

  Machines({
    this.name,
    this.description,
    this.coordinates,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'coordinates': coordinates?.toMap(),
    };
  }

  factory Machines.fromMap(Map<String, dynamic> map) {
    return Machines(
      name: map['name'],
      description: map['description'],
      coordinates: map['coordinates'] != null ? Coordinates.fromMap(map['coordinates']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Machines.fromJson(String source) => Machines.fromMap(json.decode(source));
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
