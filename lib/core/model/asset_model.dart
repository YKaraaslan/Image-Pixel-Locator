import 'dart:convert';

class GameModel {
  String? name;
  String? description;
  String? manufacturer;
  String? denom;
  String? uniqueID;
  List<Machines?>? machines;
  bool? isExpanded;
  bool? isMultiDenom;
  bool? isProgressive;

  GameModel({
    this.name,
    this.description,
    this.manufacturer,
    this.denom,
    this.uniqueID,
    this.machines,
    this.isExpanded,
    this.isMultiDenom,
    this.isProgressive,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'manufacturer': manufacturer,
      'denom': denom,
      'uniqueID': uniqueID,
      'machines': machines?.map((x) => x?.toMap()).toList(),
      'isExpanded': isExpanded,
      'isMultiDenom': isMultiDenom,
      'isProgressive': isProgressive,
    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      name: map['name'],
      description: map['description'],
      manufacturer: map['manufacturer'],
      denom: map['denom'],
      uniqueID: map['uniqueID'],
      machines: map['machines'] != null
          ? List<Machines?>.from(
              map['machines']?.map((x) => Machines?.fromMap(x)))
          : null,
      isExpanded: map['isExpanded'],
      isMultiDenom: map['isMultiDenom'],
      isProgressive: map['isProgressive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GameModel.fromJson(String source) =>
      GameModel.fromMap(json.decode(source));
}

class Machines {
  String? name;
  String? description;
  String? drawType;
  String? assetType;
  Coordinates? coordinates;

  Machines({
    this.name,
    this.description,
    this.drawType,
    this.assetType,
    this.coordinates,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'drawType': drawType,
      'assetType': assetType,
      'coordinates': coordinates?.toMap(),
    };
  }

  factory Machines.fromMap(Map<String, dynamic> map) {
    return Machines(
      name: map['name'],
      description: map['description'],
      drawType: map['drawType'],
      assetType: map['assetType'],
      coordinates: map['coordinates'] != null
          ? Coordinates.fromMap(map['coordinates'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Machines.fromJson(String source) =>
      Machines.fromMap(json.decode(source));

  Machines copyWith({
    String? name,
    String? description,
    String? drawType,
    String? assetType,
    Coordinates? coordinates,
  }) {
    return Machines(
      name: name ?? this.name,
      description: description ?? this.description,
      drawType: drawType ?? this.drawType,
      assetType: assetType ?? this.assetType,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}

class Coordinates {
  double? startX;
  double? startY;
  double? endX;
  double? endY;

  Coordinates({
    this.startX,
    this.startY,
    this.endX,
    this.endY,
  });

  Map<String, dynamic> toMap() {
    return {
      'startX': startX,
      'startY': startY,
      'endX': endX,
      'endY': endY,
    };
  }

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      startX: map['startX']?.toDouble(),
      startY: map['startY']?.toDouble(),
      endX: map['endX']?.toDouble(),
      endY: map['endY']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Coordinates.fromJson(String source) =>
      Coordinates.fromMap(json.decode(source));
}
