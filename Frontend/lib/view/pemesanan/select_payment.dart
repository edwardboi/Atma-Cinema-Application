import 'package:flutter/material.dart';
import 'package:main/entity/film.dart';
import 'package:main/entity/jadwal.dart';
import 'package:main/entity/jamTayang.dart';
import 'package:main/view/pemesanan/order_summary.dart';

class SelectPayment extends StatelessWidget {
  final Film film;
  final int jumlahKursi;
  final double totalHarga;
  final JamTayang jamTayang;
  final Jadwal jadwal;
    
  const SelectPayment({super.key, required this.film, required this.jumlahKursi, required this.totalHarga, required this.jamTayang, required this.jadwal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Payment',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 61, 41),
      ),
      
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'E-Wallet',
              textAlign: TextAlign.left,
              style: TextStyle( 
                fontWeight: FontWeight.bold,
                fontSize: 34.0,
              ),  
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSummary(film: film, jumlahKursi: jumlahKursi, totalHarga: totalHarga, jamTayang: jamTayang, jadwal: jadwal, image: 'images/payment/dana.png', payment: 'Dana'),
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 80),
                    maximumSize: Size(80, 80), 
                    backgroundColor: Colors.grey[400], 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), 
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Center( 
                    child: Image.asset(
                      'images/payment/dana.png',
                      width: 70, 
                      height: 70, 
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSummary(film: film, jumlahKursi: jumlahKursi, totalHarga: totalHarga, jamTayang: jamTayang, jadwal: jadwal, image: 'images/payment/shoppepay.png', payment: 'ShopeePay'),
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 80), 
                    maximumSize: Size(80, 80),
                    backgroundColor: Colors.grey[400], 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), 
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Center( 
                    child: Image.asset(
                      'images/payment/shoppepay.png',
                      width: 70, 
                      height: 70, 
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSummary(film: film, jumlahKursi: jumlahKursi, totalHarga: totalHarga, jamTayang: jamTayang, jadwal: jadwal, image: 'images/payment/ovo.png', payment: 'OVO'),
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 80), 
                    maximumSize: Size(80, 80),
                    backgroundColor: Colors.grey[400], 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), 
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Center( 
                    child: Image.asset(
                      'images/payment/ovo.png',
                      width: 70, 
                      height: 70, 
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSummary(film: film, jumlahKursi: jumlahKursi, totalHarga: totalHarga, jamTayang: jamTayang, jadwal: jadwal, image: 'images/payment/gopay.png' , payment: 'GoPay'),
                      )
                    );
                  },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(80, 80), 
                maximumSize: Size(80, 80),
                backgroundColor: Colors.grey[400], 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), 
                ),
                padding: EdgeInsets.zero,
              ),
              child: Center( 
                child: Image.asset(
                  'images/payment/gopay.png',
                  width: 70, 
                  height: 70, 
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              'QRIS',
              textAlign: TextAlign.left,
              style: TextStyle( 
                fontWeight: FontWeight.bold,
                fontSize: 34.0,
              ),  
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSummary(film: film, jumlahKursi: jumlahKursi, totalHarga: totalHarga, jamTayang: jamTayang, jadwal: jadwal, image: 'images/payment/qris.png', payment: 'QRIS'),
                      )
                    );
                  },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(80, 80), 
                maximumSize: Size(80, 80),
                backgroundColor: Colors.grey[400], 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), 
                ),
                padding: EdgeInsets.zero,
              ),
              child: Center( 
                child: Image.asset(
                  'images/payment/qris.png',
                  width: 70, 
                  height: 70, 
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}