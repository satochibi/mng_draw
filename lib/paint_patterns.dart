import 'dart:ui';

Map<String, Object> normal() {
  return {
    "width": 1,
    "height": 1,
    "data": const [Offset(0, 0)]
  };
}

Map<String, Object> rough3x3() {
  return {
    "width": 3,
    "height": 3,
    "data": const [Offset(2, 2)]
  };
}

Map<String, Object> rough2x2() {
  return {
    "width": 2,
    "height": 2,
    "data": const [Offset(1, 1)]
  };
}

Map<String, Object> beads4x4() {
  return {
    "width": 4,
    "height": 4,
    "data": const [
      Offset(2, 0),
      Offset(1, 1),
      Offset(3, 1),
      Offset(0, 2),
      Offset(1, 3),
      Offset(3, 3)
    ]
  };
}

Map<String, Object> stripeX() {
  return {
    "width": 1,
    "height": 2,
    "data": const [Offset(0, 0)]
  };
}

Map<String, Object> stripeY() {
  return {
    "width": 2,
    "height": 1,
    "data": const [Offset(0, 0)]
  };
}

Map<String, Object> checkered() {
  return {
    "width": 2,
    "height": 2,
    "data": const [Offset(1, 0), Offset(0, 1)]
  };
}

Map<String, Object> dense2x2() {
  return {
    "width": 2,
    "height": 2,
    "data": const [Offset(0, 0), Offset(1, 0), Offset(0, 1)]
  };
}

Map<String, Object> dense3x3() {
  return {
    "width": 3,
    "height": 3,
    "data": const [
      Offset(0, 0),
      Offset(1, 0),
      Offset(2, 0),
      Offset(0, 1),
      Offset(1, 1),
      Offset(2, 1),
      Offset(0, 2),
      Offset(1, 2)
    ]
  };
}

Map<String, Object> leftHatching8x8() {
  return {
    "width": 8,
    "height": 8,
    "data": const [
      Offset(1, 0),
      Offset(2, 1),
      Offset(3, 2),
      Offset(4, 3),
      Offset(5, 4),
      Offset(6, 5),
      Offset(7, 6),
      Offset(0, 7)
    ]
  };
}

Map<String, Object> rightHatching8x8() {
  return {
    "width": 8,
    "height": 8,
    "data": const [
      Offset(7, 0),
      Offset(6, 1),
      Offset(5, 2),
      Offset(4, 3),
      Offset(3, 4),
      Offset(2, 5),
      Offset(1, 6),
      Offset(0, 7)
    ]
  };
}
