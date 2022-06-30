enum Types {
  none,
  rectangle,
  circle,
  line,
  point,
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
    } else if (this == Types.point.getName()) {
      return Types.point;
    } else {
      return Types.none;
    }
  }
}
