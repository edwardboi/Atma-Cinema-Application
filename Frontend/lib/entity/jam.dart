import 'dart:convert';

class Jam {
  int id;
  String jam;
  // bool isAvailable;
  // bool isSelected;

  Jam({
    required this.id,
    required this.jam,
  });

  factory Jam.fromRawJson(String str) => Jam.fromJson(json.decode(str));
  factory Jam.fromJson(Map<String, dynamic> json) => Jam(
    id: json["id"],
    jam: json["jam"],
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "jam": jam,
  };

}