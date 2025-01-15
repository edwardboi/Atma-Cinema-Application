import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';
import 'package:main/entity/ticket.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'preview_screen.dart';
import 'package:barcode/barcode.dart';

void generatePdf(BuildContext context, Ticket ticket) async {
  final pdf = pw.Document();

  final qrCode = Barcode.qrCode();

  final logoImage = pw.MemoryImage(
    (await rootBundle.load('images/logo.png')).buffer.asUint8List(),
  );

  final cobaImage = pw.MemoryImage(
    (await rootBundle.load('${ticket.gambar_film}')).buffer.asUint8List(),
  );

  final tiketImage = pw.MemoryImage(
    (await rootBundle.load('images/ticketBayar.png')).buffer.asUint8List(),
  );

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Container(
          padding: const pw.EdgeInsets.all(2),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromInt(0xFF213D29),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          alignment: pw.Alignment.center,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 20),
              pw.Image(logoImage, width: 100, height: 100),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(8),
                  color: PdfColor.fromInt(0xFF182C1D),
                  border: pw.Border.all(
                    color: PdfColor.fromInt(0xFF182C1D),
                    width: 1,
                  ),
                ),
                child: pw.Row(
                  children: [
                    pw.SizedBox(width: 20),
                    pw.Expanded(
                      child: pw.Container(
                        width: 200,
                        height: 200,
                        child: pw.ClipRRect(
                          child: pw.Image(
                            cobaImage,
                            fit: pw.BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'ATMA CINEMA, ${ticket.tipe_studio}',
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xFFFFFFFF),
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          ticket.nama_film!,
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xFFFFFFFF),
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        pw.SizedBox(height: 40),
                        pw.Row(
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('KODE PEMESANAN  ',
                                    style:
                                        pw.TextStyle(color: PdfColors.white)),
                                pw.Text('(JUMLAH) TIKET  ',
                                    style:
                                        pw.TextStyle(color: PdfColors.white)),
                              ],
                            ),
                            pw.SizedBox(width: 20),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  ': ${ticket.id}',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white,
                                  ),
                                ),
                                pw.Text(
                                  ': ${ticket.jumlahKursi} Tiket',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.Text(
                          '${DateFormat('EEEE, dd MMMM yyyy').format(ticket.tanggal_tayang!)} | ${ticket.jam}',
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xFFFFFFFF),
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                width: 475,
                height: 70,
                child: pw.Image(tiketImage, fit: pw.BoxFit.cover),
              ),
              pw.SizedBox(height: 20),
              pw.SizedBox(width: 20),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('NOMOR TIKET',
                          style: pw.TextStyle(color: PdfColors.white)),
                      pw.SizedBox(height: 15),
                      pw.Text('KURSI REGULER',
                          style: pw.TextStyle(color: PdfColors.white)),
                      pw.Text('BIAYA LAYANAN',
                          style: pw.TextStyle(color: PdfColors.white)),
                      pw.Text('STATUS PEMBAYARAN',
                          style: pw.TextStyle(color: PdfColors.white)),
                      pw.Text('TOTAL PEMBAYARAN',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white)),
                    ],
                  ),
                  pw.SizedBox(width: 227),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        '${ticket.id}',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Text(
                        'Rp${NumberFormat('#,##0', 'en_US').format(ticket.studioHarga)} x ${ticket.jumlahKursi}',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white),
                      ),
                      pw.Text(
                        'Rp4,000 X ${ticket.jumlahKursi}',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white),
                      ),
                      pw.Text(
                        'Lunas',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white),
                      ),
                      pw.Text('${ticket.harga}',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 25),
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(8),
                    color: PdfColor.fromInt(0xFF182C1D),
                    border: pw.Border.all(
                      color: PdfColor.fromInt(0xFF182C1D),
                      width: 1,
                    ),
                  ),
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    color: PdfColors.white,
                    child: pw.SizedBox(
                      width: 140,
                      height: 140,
                      child: pw.BarcodeWidget(
                        barcode: qrCode,
                        data:
                            '${ticket.id} dan ${ticket.id_pemesanan} / user ${ticket.id_user}',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PreviewScreen(doc: pdf),
    ),
  );
}