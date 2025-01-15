import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:main/client/PemesananClient.dart';

import 'package:main/entity/film.dart';
import 'package:main/entity/jadwal.dart';
import 'package:main/entity/jamTayang.dart';
import 'package:main/view/pemesanan/order_summary.dart';

class BookSeat extends StatefulWidget {
  final Film film; 
  final JamTayang jamTayang;
  final Jadwal jadwal;

  const BookSeat({super.key, required this.film, required this.jamTayang, required this.jadwal});

  @override
  State<BookSeat> createState() => _BookSeatState();
}

class _BookSeatState extends State<BookSeat> {
  int seatCount = 0; 
  late final double pricePerSeat;
  int? sisaKapasitas;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    pricePerSeat = double.parse(widget.jamTayang.harga);

    isLoading = true;
    _fetchSisaKapasitas();
  }

  void _fetchSisaKapasitas() async {
    try {
      int kapasitas = await PemesananClient.getSisaKapasitas(
        idJadwal: widget.jadwal.id,
        idStudio: widget.jamTayang.id_studio,
        idJamTayang: widget.jamTayang.id,
        idFilm: widget.film.id,
      );

      setState(() {
        sisaKapasitas = kapasitas;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching kapasitas: $error');
    }
  }

  // Fungsi menambah jumlah seat
  void incrementSeat() {
    if (sisaKapasitas != null && sisaKapasitas! != 0) {
      setState(() {
        seatCount++;
        if (sisaKapasitas != null) {
          sisaKapasitas = sisaKapasitas! - 1;
        }
      });
    } else {
      showSnackBar(context, 'Sudah tidak ada sisa kursi', Colors.red);
    }
  }

  // Fungsi mengurangi jumlah seat
  void decrementSeat() {
    if (seatCount > 0) {
      setState(() {
        seatCount--;
        if (sisaKapasitas != null) {
          sisaKapasitas = sisaKapasitas! + 1;
        }
      });
    }
  }

  // Menghitung total harga 
  double get totalPrice {
    return seatCount * pricePerSeat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.film.nama_film,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '${DateFormat('dd MMM').format(widget.jadwal.tanggal_tayang)} | ${widget.jamTayang.jam}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 33, 61, 41),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
            image: AssetImage('${widget.film.gambar_film}'),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //ini kartu buat totharganya
                  Card(
                    color: Color.fromARGB(255, 24, 44, 29),
                    child: Padding(
                      
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Total: Rp${totalPrice.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  //nah ini kartu buat dalemannya
                  Card(
                    color: Color(0xFF213D29),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Kursi yang tersedia : $sisaKapasitas',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Total Seat',
                            style: TextStyle(
                              fontSize: 38.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.width * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  shape: BoxShape.rectangle,
                                  color: Colors.black54,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.remove, color: Colors.white),
                                  iconSize: 30, // Set icon size
                                  onPressed: decrementSeat,
                                ),
                              ),
                              SizedBox(width: 70),
                              Text(
                                '$seatCount',
                                style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 60),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.width * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  
                                  shape: BoxShape.rectangle,
                                  color: Colors.black54,
                                  
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.add, color: Colors.white),
                                  iconSize: 30, // Set icon size
                                  onPressed: incrementSeat,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ElevatedButton(
          onPressed: seatCount > 0
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderSummary(film: widget.film, jumlahKursi: seatCount, totalHarga: totalPrice, jamTayang: widget.jamTayang, jadwal: widget.jadwal, image: 'images/payment/gopay.png', payment: 'GoPay'),
                  )
                );
              }
            : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 33, 61, 41),
            disabledBackgroundColor: Colors.grey,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: Text(
            "Complete Payment",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, String msg, Color bg) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: bg,
      action: SnackBarAction(
          label: 'hide', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}