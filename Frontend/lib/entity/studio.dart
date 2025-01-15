import 'dart:convert';

class Studio {
  int id;
  int kapasitas;
  String tipe_studio;
  String harga;

  Studio({
    required this.id,
    required this.kapasitas,
    required this.tipe_studio,
    required this.harga,
  });

  factory Studio.fromRawJson(String str) => Studio.fromJson(json.decode(str));
  factory Studio.fromJson(Map<String, dynamic> json) => Studio(
    id: json["id"],
    kapasitas: json["kapasitas"],
    tipe_studio: json["tipe_studio"],
    harga: json["harga"],
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "kapasitas": kapasitas,
    "tipe_studio": tipe_studio,
    "harga": harga,
  };
}