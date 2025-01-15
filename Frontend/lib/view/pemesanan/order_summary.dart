import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:main/client/TicketClient.dart';
import 'package:main/client/UserClient.dart';
import 'package:main/entity/film.dart';
import 'package:main/entity/jadwal.dart';
import 'package:main/entity/jamTayang.dart';
import 'package:main/entity/pemesanan.dart';
import 'package:main/entity/ticket.dart';
import 'package:main/entity/user.dart';
import 'package:main/view/pemesanan/payment_success.dart';
import 'package:main/view/pemesanan/select_payment.dart';

import 'package:main/client/PemesananClient.dart';

class OrderSummary extends StatefulWidget {
  final Film film;
  final int jumlahKursi;
  final double totalHarga;
  final JamTayang jamTayang;
  final Jadwal jadwal;
  final String image;
  final String payment;

  const OrderSummary({super.key, required this.film, required this.jumlahKursi, required this.totalHarga, required this.jamTayang, required this.jadwal, required this.image, required this.payment});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  int selectedValue = 0;
  late final double totalHargaFix;
  late Future<User> _currentUser; 
  late Future<List<Ticket>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    totalHargaFix = widget.totalHarga + (4000 * widget.jumlahKursi);

    _currentUser = UserClient.fetchCurrentUser(); 

    _ticketsFuture = TicketClient.fetchAll();
  }

  void onSubmit(User user) async {
    Pemesanan input = Pemesanan(
      id_film: widget.film.id, 
      id_jadwal: widget.jadwal.id, 
      id_jamtayang: widget.jamTayang.id,
      id_user: user.id,
      harga: totalHargaFix,
      jumlahKursi: widget.jumlahKursi,
    );

    try {
      final int pemesananId = await PemesananClient.create(input);

      Pemesanan pemesanan = await PemesananClient.fetchById(pemesananId);
      print(pemesanan);

      Ticket ticketInput = Ticket(
        id_pemesanan: pemesananId,
        tanggal_pemesanan: DateTime.now(),
      );

      final int ticketId = await TicketClient.create(ticketInput);

      Ticket ticket = await TicketClient.fetchById(ticketId);

      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute( 
          builder: (context) => PaymentSuccess(ticket: ticket, payment: widget.payment),
        ),
        (Route<dynamic> route) => route.isFirst,
      );
            

      showSnackBar(context, "Success", Colors.green);
    } catch (err) {
      print('Error: ${err.toString()}');
      showSnackBar(context, err.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Order Summary',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 61, 41),
      ),

      body: FutureBuilder<User>(
        future: _currentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('User tidak ditemukan'));
          } else {
            final user = snapshot.data!;
            
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(widget.film.gambar_film),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Atma Cinema',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 219, 196, 127),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.film.nama_film,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 33, 61, 41),
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                color: const Color.fromARGB(255, 0, 255, 0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                                  child: Text(
                                    widget.film.rating_usia,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              
                              Text(
                                widget.jamTayang.tipe_studio,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: const Color.fromARGB(255, 33, 61, 41),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              
                              Text(
                                '${DateFormat('EEEE, dd MMMM yyyy').format(widget.jadwal.tanggal_tayang)} | ${widget.jamTayang.jam}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: const Color.fromARGB(255, 33, 61, 41),
                                  fontWeight: FontWeight.bold
                                ),
                                softWrap: true,  
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'NEW ORDER: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ),

                      Divider(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Transaction Detail',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 33, 61, 41),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  // harusnya ambil jumlah tiket dari page sebelumnya
                                  '${widget.jumlahKursi} Ticket',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'REGULAR SEAT',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'SERVICE FEE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'To help improve our services',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  ' ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'Rp${widget.jamTayang.harga} x ${widget.jumlahKursi}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'Rp4,000 x ${widget.jumlahKursi}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      Divider(),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Payment Method',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 33, 61, 41),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Image.asset(
                              '${widget.image}', 
                              width: 70, 
                              height: 70,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              '${widget.payment}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            
                          ],
                        ),
                      ),

                      SizedBox(height: 12.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center, 
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectPayment(film: widget.film, jumlahKursi: widget.jumlahKursi, totalHarga: widget.totalHarga, jamTayang: widget.jamTayang, jadwal: widget.jadwal),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.blue, width: 1),
                              minimumSize: Size(255, 40), 
                              maximumSize: Size(255, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), 
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              'Select Another Payment',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20), 

                          Text(
                            '* Ticket purchases cannot be changed / cancelled',
                            style: TextStyle(
                              color: Colors.redAccent[100],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 20),
                  Container(
                    height: 70,
                    color: Colors.yellowAccent[700],
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 20, 
                          child: Image.asset(
                            'images/payment/motic.png', 
                            width: 60,
                            height: 60,
                          ),
                        ),
                        
                        Positioned(
                          right: 0,
                          top: -10, 
                          child: Image.asset(
                            'images/payment/reel.png', 
                            width: 50,
                            height: 50,
                          ),
                        ),
                        
                        Center(
                          child: Text(
                            'Hooray lets finish your payment',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: const Color.fromARGB(255, 33, 61, 41),
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 70,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Text(
                            'TOTAL PAYMENT',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Rp ${NumberFormat('#,##0', 'en_US').format(totalHargaFix)}',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 33, 61, 41),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ElevatedButton(
                      onPressed: () => onSubmit(user),
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

                ],
              ),
            );

          }
        },
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
