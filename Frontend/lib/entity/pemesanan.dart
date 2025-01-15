import 'dart:convert';

import 'package:intl/intl.dart';

class Pemesanan {
  int? id;
  int id_film;
  int id_jadwal;
  int id_jamtayang;
  int id_user;
  double harga;
  int jumlahKursi;
  String? nama_film;
  DateTime? tanggal_tayang;
  String? tipe_studio;
  double? studioHarga;
  String? jam;

  Pemesanan({
    this.id,
    required this.id_film,
    required this.id_jadwal,
    required this.id_jamtayang,
    required this.id_user,
    required this.harga,
    required this.jumlahKursi,
    this.nama_film,
    this.tanggal_tayang,
    this.tipe_studio,
    this.studioHarga,
    this.jam,
  });

  factory Pemesanan.fromRawJson(String str) => Pemesanan.fromJson(json.decode(str));
  factory Pemesanan.fromJson(Map<String, dynamic> json) => Pemesanan(
    id: json["id"],
    id_film: json["id_film"],
    id_jadwal: json["id_jadwal"],
    id_jamtayang: json["id_jamtayang"],
    id_user: json["id_user"],
    harga:  _parseDouble(json["harga"]),
    jumlahKursi: json["jumlah_kursi"],
    nama_film: json["nama_film"],
    tanggal_tayang: DateTime.parse(json["tanggal_tayang"]),
    tipe_studio: json["tipe_studio"],
    studioHarga:  _parseDouble(json["studioHarga"]),
    jam: json["jam"],
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "id_film": id_film,
    "id_jadwal": id_jadwal,
    "id_jamtayang": id_jamtayang,
    "id_user": id_user,
    "harga": harga,
    "jumlah_kursi": jumlahKursi,

  };


  static double _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      return 0.0;
    }
  }

}