import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:main/view/login.dart';
import 'package:main/view/profile/personal_info.dart';
import 'package:main/view/profile/review.dart';
import 'package:main/view/home/welcome.dart';
import 'package:main/view/home/tiket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:main/client/UserClient.dart'; 
import 'package:main/entity/user.dart';
import 'package:main/view/profile/wishlistPage.dart';

class ProfilHome extends StatefulWidget {
  const ProfilHome({super.key});

  @override
  State<ProfilHome> createState() => _ProfilHomeState();
}

class _ProfilHomeState extends State<ProfilHome> {
  late Future<User> _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = UserClient.fetchCurrentUser();
  }


  Future<void> _logout() async {
    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token'); 
      print('Token saat logout: $token'); 

      if (token != null) {
        
        await UserClient.logout(token);

      
        await prefs.remove('auth_token');

      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const LoginForm()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Token tidak ditemukan. Harap login kembali.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan saat logout: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 33, 61, 41),
          title: Text(
            'Profile',
            
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Column(children: [
            const SizedBox(height: 25),
            FutureBuilder<User>(
                future:
                    _currentUser, 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); 
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Error: ${snapshot.error}')); 
                  }

                  if (snapshot.hasData) {
                    User user =
                        snapshot.data!; 
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                'https://ivory-stingray-881568.hostingersite.com/${user.foto}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.nama, // Ambil nama dari user
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
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  user.telp, // Ambil nomor telpon dari user
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  // Default: jika tidak ada data
                  return Center(child: Text('Data pengguna tidak ditemukan.'));
                }),
            const SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text("Personal Info"),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: const Color.fromARGB(255, 33, 61, 41),
                  ),
                ),
                tileColor: Colors.white,
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PersonalInfoPage()));
                },
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text("My Ticket"),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.card_travel,
                        color: const Color.fromARGB(255, 33, 61, 41),
                      ),
                    ),
                    tileColor: Colors.white,
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Welcome(selectedIndex: 3)),
                      );
                    },
                  ),
                  ListTile(
                    title: Text("My Film"),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Icon(
                        Icons.favorite_border_outlined,
                        color: const Color.fromARGB(255, 33, 61, 41),
                      ),
                    ),
                    tileColor: Colors.white,
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Wishlistpage()),
                      );
                    },
                  ),

                  ListTile(
                    title: Text("User Reviews"),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Icon(Icons.rate_review_sharp, color: const Color.fromARGB(255, 33, 61, 41)),
                    ),
                    tileColor: Colors.white,
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Reviewer()));
                    },
                  ),
                  
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  
                  
                  
                ],
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap:
                  _logout, // Panggil fungsi logout saat tombol logout ditekan
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                    title: Text("Log Out"),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                    ),
                    tileColor: Colors.white,
                    trailing: Icon(Icons.chevron_right)),
              ),
            )
          ])),
        ));
  }
}
