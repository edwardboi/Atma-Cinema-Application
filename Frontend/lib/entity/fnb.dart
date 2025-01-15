import 'dart:convert';



class Fnb {
  int id;
  String nama_menu;
  String gambar;
  String jenis;
  String harga;

  Fnb({required this.id, required this.nama_menu, required this.gambar, required this.jenis, required this.harga});


  factory Fnb.fromRawJson(String str) => Fnb.fromJson(json.decode(str));
  factory Fnb.fromJson(Map<String, dynamic> json) => Fnb(
    id: json["id"],
    nama_menu: json["nama_menu"],
    gambar: json["gambar"],
    jenis: json["jenis"],
    harga: json["harga"],
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_menu": nama_menu,
    "gambar": gambar,
    "jenis": jenis,
    "harga": harga,
  };
}
