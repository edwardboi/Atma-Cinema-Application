import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:main/entity/ticket.dart';

import 'package:main/view/home/welcome.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:main/view/pemesanan/pdf_view.dart';

class TicketDetail extends StatefulWidget {
  final Ticket ticket;

  const TicketDetail({super.key, required this.ticket});

  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Welcome(selectedIndex: 3, indextab: 0)),
            );
          },
        ),
        title: Text(
          'Tickets',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 61, 41),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 189, 198, 173),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QrImageView( 
                      backgroundColor: Colors.white,
                      data: '${widget.ticket.id} dan ${widget.ticket.id_pemesanan} / user ${widget.ticket.id_user}',
                      version: 6,
                      padding: const EdgeInsets.all(8),
                      size: 150.0,
                    ), 
                    SizedBox(height: 20),
                    Text(
                      widget.ticket.nama_film!,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 33, 61, 41),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      softWrap: true,
                    ),
                    Text(
                      'ATMA CINEMA, ${widget.ticket.tipe_studio}',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 33, 61, 41),
                        fontSize: 13,
                      ),
                      softWrap: true,
                    ),
                    Text(
                      '${DateFormat('EEEE, dd MMMM yyyy').format(widget.ticket.tanggal_tayang!)} | ${widget.ticket.jam}',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 33, 61, 41),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                    Divider(color: Colors.grey),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kode Pemesanan',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '(Jumlah) TIKET',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.ticket.id}',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${widget.ticket.jumlahKursi}',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NUMBER ORDER',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'KURSI REGULER',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'BIAYA LAYANAN',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'STATUS PEMBAYARAN',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${widget.ticket.id}',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Rp ${NumberFormat('#,##0', 'en_US').format(widget.ticket.studioHarga)} X ${widget.ticket.jumlahKursi}',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rp4,000 X ${widget.ticket.jumlahKursi}',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Lunas',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 33, 61, 41),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey),
                    Row(
                      children: [
                        Text(
                          'TOTAL PEMBAYARAN',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 33, 61, 41),
                            fontSize: 13,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Rp ${NumberFormat('#,##0', 'en_US').format(widget.ticket.harga)}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 33, 61, 41),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: 
                    () {
                        generatePdf(context, widget.ticket);
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 33, 61, 41),
                    disabledBackgroundColor: Colors.grey,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Print Ticket",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '* TERMASUK PAJAK',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  Divider(color: Colors.grey),
                  Text(
                    'PT. Atma Jaya Yogyakarta',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'NPWP: 081.970.503.3-099.000',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Sleman City Hall Lt.9',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Jl. Magelang Jl. Gito Gati No.KM 9, Denggung, Tridadi,',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Kec. Sleman, Kab. Sleman, DIY Yogyakarta, 55511',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  Divider(color: Colors.grey),
                  Text(
                    'Tiket yang sudah dibeli tidak dapat diganti / direfund',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),

    );
  }
}