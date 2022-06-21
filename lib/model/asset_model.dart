import 'dart:convert';

class GameModel {
  String? name;
  String? description;
  String? type;
  List<Machines?>? machines;

  GameModel({
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

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      name: map['name'],
      description: map['description'],
      type: map['type'],
      machines: map['machines'] != null ? List<Machines?>.from(map['machines']?.map((x) => Machines?.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameModel.fromJson(String source) => GameModel.fromMap(json.decode(source));
}

class Machines {
  String? name;
  String? description;
  String? type;
  Coordinates? coordinates;

  Machines({
    this.name,
    this.description,
    this.type,
    this.coordinates,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'coordinates': coordinates?.toMap(),
    };
  }

  factory Machines.fromMap(Map<String, dynamic> map) {
    return Machines(
      name: map['name'],
      description: map['description'],
      type: map['type'],
      coordinates: map['coordinates'] != null ? Coordinates.fromMap(map['coordinates']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Machines.fromJson(String source) => Machines.fromMap(json.decode(source));
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

  factory Coordinates.fromJson(String source) => Coordinates.fromMap(json.decode(source));
}

enum Types {
  none,
  rectangle,
  circle,
  line,
}

extension ParseToString on Types {
  String getName() {
    return toString().split('.').last.capitalize();
  }
}

extension CapitalizeString on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  Types getType() {
    if (this == Types.rectangle.getName()) {
      return Types.rectangle;
    } else if (this == Types.circle.getName()) {
      return Types.circle;
    } else if (this == Types.line.getName()) {
      return Types.line;
    } else {
      return Types.none;
    }
  }
}
