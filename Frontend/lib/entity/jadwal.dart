import 'dart:convert';
import 'package:intl/intl.dart';

class Jadwal {
  int id;
  DateTime tanggal_tayang;

  Jadwal({
    required this.id,
    required this.tanggal_tayang,
  });

  factory Jadwal.fromRawJson(String str) => Jadwal.fromJson(json.decode(str));
  factory Jadwal.fromJson(Map<String, dynamic> json) => Jadwal(
    id: json["id"],
    tanggal_tayang: DateTime.parse(json["tanggal_tayang"]),
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "tanggal_tayang": DateFormat('yyyy-MM-dd').format(tanggal_tayang),
  };

}