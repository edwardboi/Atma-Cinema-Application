import 'dart:convert';

import 'package:main/entity/jam.dart';
import 'package:main/entity/studio.dart';

class JamTayang {
  int id;
  int id_studio;
  int id_jam;
  // Jam jam;
  // Studio studio;
  int kapasitas;
  String tipe_studio;
  String harga;
  String jam;
  bool isAvailable;
  bool isSelected;

  JamTayang({
    required this.id,
    required this.id_studio,
    required this.id_jam,
    required this.kapasitas,
    required this.tipe_studio,
    required this.harga,
    required this.jam,
    this.isAvailable = true,
    this.isSelected = false,
  });

  factory JamTayang.fromRawJson(String str) => JamTayang.fromJson(json.decode(str));
  factory JamTayang.fromJson(Map<String, dynamic> json) => JamTayang(
    id: json["id"],
    id_studio: json["id_studio"],
    id_jam: json["id_jam"],
    kapasitas: json["kapasitas"],
    tipe_studio: json["tipe_studio"],
    harga: json["harga"],
    jam: json["jam"],
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "id_studio": id_studio,
    "id_jam": id_jam,
    "kapasitas": kapasitas,
    "tipe_studio": tipe_studio,
    "harga": harga,
    "jam": jam,
  };

}

