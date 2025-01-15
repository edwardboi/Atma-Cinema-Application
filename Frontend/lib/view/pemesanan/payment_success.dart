import 'package:flutter/material.dart';

import 'package:main/entity/ticket.dart';
import 'package:main/view/pemesanan/ticket_detail.dart';

class PaymentSuccess extends StatefulWidget {
  final Ticket ticket;
  final String payment;

  const PaymentSuccess({super.key, required this.ticket, required this.payment});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color:const Color.fromARGB(255, 33, 61, 41),
                borderRadius: BorderRadius.circular(8), 
              ),
              child: Icon(
                Icons.check,
                size: 80,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 33, 61, 41),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'You successfully maked a payment.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'enjoy our service!',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: 
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton( 
              onPressed :
                () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketDetail(ticket: widget.ticket)),
                    );
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 33, 61, 41),
                disabledBackgroundColor: Colors.grey,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "See Ticket",
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