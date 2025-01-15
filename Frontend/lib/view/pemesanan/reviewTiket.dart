import 'package:flutter/material.dart';

import 'package:main/client/reviewClient.dart';

import 'package:main/entity/review.dart';
import 'package:main/entity/ticket.dart';
import 'package:main/entity/user.dart';
import 'package:main/client/UserClient.dart';
import 'package:main/view/home/isiHome.dart';
import 'package:main/view/home/welcome.dart';

class ReviewTiket extends StatefulWidget {
  final Ticket history;

  const ReviewTiket({super.key, this.id, required this.history});
  final int? id;

  @override
  _ReviewTiketState createState() => _ReviewTiketState();
}

class _ReviewTiketState extends State<ReviewTiket> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 0; // Menyimpan rating yang dipilih
  final commentController = TextEditingController();
  
  Future<User> _fetchCurrentUser() async {
    try {
      User currentUser = await UserClient.fetchCurrentUser();
      return currentUser;
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }
  bool _isLoading = false; 
  

  @override
  Widget build(BuildContext context) {
    void onSubmit() async {
      if (!_formKey.currentState!.validate()) return;
      User currentUser = await _fetchCurrentUser();
      Review input = Review(
          id_film: widget.history.id_film!, 
          id_user: currentUser.id,
          id_tiket: widget.history.id!,
          nama: currentUser.nama,
          foto: currentUser.foto,
          komentar: commentController.text,
          rating_film: _rating);

      try {
          await ReviewClient.create(input);
          
          showSnackBar(context, "Success", Colors.green);
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Welcome(selectedIndex: 3, indextab: 0),
            ),
          );

      } catch (err) {
        print('Error: ${err.toString()}');
        showSnackBar(context, err.toString(), Colors.red);
        // Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 61, 41),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text('Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 33, 61, 41),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      '${widget.history.gambar_film}',
                      width: 200,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${widget.history.nama_film}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _rating = index + 1; // Mengubah rating sesuai yang dipilih
                            });
                          },
                          child: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.yellow,
                            size: 30,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // TextField untuk komentar
              TextField(
                controller: commentController, // Kontrol input komentar
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Komentar tentang film',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 20),
              // Tombol Kirim Review
              ElevatedButton(
                onPressed: onSubmit, // Nonaktifkan tombol jika sedang loading
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white) // Indikator loading
                    : Text('Kirim'),
              ),
            ],
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
