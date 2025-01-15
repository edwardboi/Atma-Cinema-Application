import 'package:flutter/material.dart';
import 'package:main/view/profile/camera.dart';
import 'package:main/view/profile/personal_info.dart';
import 'package:main/client/UserClient.dart'; // Pastikan UserClient sudah diimport
import 'package:main/entity/user.dart'; // Pastikan entitas User sudah diimport
import 'dart:convert';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // Fungsi untuk mendapatkan data user saat ini
  Future<User> _fetchCurrentUser() async {
    try {
      User currentUser = await UserClient.fetchCurrentUser();
      return currentUser;
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 61, 41),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ikon kembali (<-)
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PersonalInfoPage()),
            );
          },
        ),
      ),
      body: FutureBuilder<User>(
        future:
            _fetchCurrentUser(), // Memanggil fetchCurrentUser untuk mendapatkan data
        builder: (context, snapshot) {
          // Cek status Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Menunggu data
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Data user tersedia, bisa digunakan
            User currentUser = snapshot.data!;
            _usernameController = TextEditingController(text: currentUser.nama);
            _emailController = TextEditingController(text: currentUser.email);
            _phoneController = TextEditingController(text: currentUser.telp);

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage('https://ivory-stingray-881568.hostingersite.com/${currentUser.foto}',),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Color.fromARGB(255, 189, 198, 173),
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Color.fromARGB(255, 33, 61, 41),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CameraView(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 25), // Jarak tambahan setelah CircleAvatar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "USERNAME",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF0F5FA),
                              labelText: 'Username',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              currentUser.nama = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "EMAIL",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF0F5FA),
                              labelText: 'Email',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              currentUser.email = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "PHONE NUMBER",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF0F5FA),
                              labelText: 'Phone Number',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              currentUser.telp = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 230),
                          Container(
                            width: 400.0,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  var updatedUser = User(
                                    id: currentUser.id,
                                    nama: currentUser.nama,
                                    email: currentUser.email,
                                    password: currentUser.password, // Kosongkan password jika tidak diubah
                                    telp: currentUser.telp,
                                    tanggal_lahir: currentUser.tanggal_lahir,
                                    foto: currentUser.foto, // Gunakan foto yang ada jika tidak diubah
                                  );
                                  String? token = await UserClient.getAuthToken();
                                  if (token == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'User is not authenticated'),
                                              backgroundColor: Colors.red,),
                                    );
                                    return;
                                  }

                                  try {
                                    final response = await UserClient.update(updatedUser, token);
                                    if (response.statusCode == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Profile updated successfully!'),
                                                backgroundColor: Colors.green,),
                                      );
                                  
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PersonalInfoPage()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to update profile'),
                                                backgroundColor: Colors.red,),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e'),
                                      backgroundColor: Colors.red,),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 33, 61, 41),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No user data available'));
          }
        },
      ),
    );
  }
}
