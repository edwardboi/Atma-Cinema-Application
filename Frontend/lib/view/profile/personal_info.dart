import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:main/client/UserClient.dart';  // Pastikan Anda memiliki UserClient
import 'package:main/entity/user.dart';       // Pastikan Anda memiliki entitas User
import 'package:main/view/home/welcome.dart';
import 'package:main/view/profile/edit.dart';
import 'package:main/view/profile/profile.dart';
import 'package:intl/intl.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  // Fungsi untuk mengambil data pengguna
  Future<User> _getUserData() async {
    return await UserClient.fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 61, 41),
        title: Text(
          'Personal Info',
          style: TextStyle( 
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline, // Garis bawah diterapkan
                ),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ikon kembali (<-)
          onPressed: () {
            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Welcome(selectedIndex: 4, indextab: 0),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: FutureBuilder<User>(
            future: _getUserData(), // Ambil data user
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Tampilkan loading saat menunggu data
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Menangani error jika ada
              }

              if (snapshot.hasData) {
                User user = snapshot.data!; // Dapatkan data user dari snapshot

                return Column(
                  children: [
                    const SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage('https://ivory-stingray-881568.hostingersite.com/${user.foto}',),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.nama,  // Tampilkan nama user
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.phone,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  user.telp,  // Tampilkan nomor telepon user
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("USERNAME"),
                            subtitle: Text(user.nama),  // Tampilkan nama dari user
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: Icon(
                                Icons.person,
                                color: const Color.fromARGB(255, 33, 61, 41),
                              ),
                            ),
                            tileColor: Colors.white,
                          ),
                          ListTile(
                            title: Text("Email"),
                            subtitle: Text(user.email),  // Tampilkan email dari user
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: Icon(
                                Icons.mail,
                                color: const Color.fromARGB(255, 33, 61, 41),
                              ),
                            ),
                            tileColor: Colors.white,
                          ),
                          ListTile(
                            title: Text("PHONE NUMBER"),
                            subtitle: Text(user.telp),  // Tampilkan nomor telepon dari user
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: Icon(
                                Icons.phone,
                                color: const Color.fromARGB(255, 33, 61, 41),
                              ),
                            ),
                            tileColor: Colors.white,
                          ),
                          ListTile(
                            title: Text("DATE OF BIRTH"),
                            subtitle: Text(DateFormat('dd-MM-yyyy').format(user.tanggal_lahir)),  // Sesuaikan dengan data jika perlu
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: Icon(
                                Icons.date_range_outlined,
                                color: const Color.fromARGB(255, 33, 61, 41),
                              ),
                            ),
                            tileColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Center(child: Text('No data available'));  // Jika tidak ada data
            },
          ),
        ),
      ),
    );
  }
}
