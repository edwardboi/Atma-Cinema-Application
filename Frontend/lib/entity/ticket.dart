import 'dart:convert';

import 'package:intl/intl.dart';

class Ticket {
  int? id;
  int id_pemesanan;
  DateTime tanggal_pemesanan;

  // Hasil dari join table
  int? id_film;
  int? id_jadwal;
  int? id_jamtayang;
  int? id_user;
  double? harga;
  int? jumlahKursi;
  String? nama_film;
  String? gambar_film;
  DateTime? tanggal_tayang;
  String? tipe_studio;
  double? studioHarga;
  String? jam;

  Ticket({
    this.id,
    required this.id_pemesanan,
    required this.tanggal_pemesanan,

    this.id_film,
    this.id_jadwal,
    this.id_jamtayang,
    this.id_user,
    this.harga,
    this.jumlahKursi,
    this.nama_film,
    this.gambar_film,
    this.tanggal_tayang,
    this.tipe_studio,
    this.studioHarga,
    this.jam,
  });

  factory Ticket.fromRawJson(String str) => Ticket.fromJson(json.decode(str));
  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json["id"],
    id_pemesanan: json["id_pemesanan"],
    tanggal_pemesanan: DateTime.parse(json["tanggal_pemesanan"]),
    id_film: json["id_film"],
    id_jadwal: json["id_jadwal"],
    id_jamtayang: json["id_jamtayang"],
    id_user: json["id_user"],
    harga: _parseDouble(json["harga"]),
    jumlahKursi: json["jumlah_kursi"],
    nama_film: json["nama_film"],
    gambar_film: json["gambar_film"],
    tanggal_tayang: DateTime.parse(json["tanggal_tayang"]),
    tipe_studio: json["tipe_studio"],
    studioHarga: _parseDouble(json["studioHarga"]),
    jam: json["jam"],
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "id_pemesanan": id_pemesanan,
    "tanggal_pemesanan": DateFormat('yyyy-MM-dd').format(tanggal_pemesanan),
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