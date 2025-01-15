import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:main/view/home/welcome.dart';
import 'package:main/view/profile/profile.dart';
import 'package:main/entity/review.dart';
import 'package:main/entity/user.dart';
import 'package:main/client/UserClient.dart';
import 'package:main/client/ReviewClient.dart';




class Reviewer extends ConsumerWidget {
  final int tabIndex;
  final currentUserProvider = FutureProvider<User>((ref) async {
    try {
      return await UserClient.fetchCurrentUser();
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  });

  Reviewer({super.key, this.tabIndex = 0});
  final listReviewProvider = FutureProvider.family<List<Review>, int>((ref, idUser) async {
    return await ReviewClient.fetchByUser(idUser);
  }); 

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 61, 41),
        title: Text(
          'User Reviews',
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
          icon: Icon(Icons.arrow_back),
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
      body: currentUser.when(
        error: (err, stack) => Center(
          child: Text('Gagal memuat data pengguna: ${err.toString()}'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (user) {
          // Gunakan listReviewProvider dengan idUser dari currentUser
          final reviewListener = ref.watch(listReviewProvider(user.id));

          return reviewListener.when(
            error: (err, s) {
              return Center(
                child: Text(
                  "Terjadi kesalahan: ${err.toString()}",
                  textAlign: TextAlign.center,
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            data: (reviews) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: reviews.map((review) {
                    
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage('https://ivory-stingray-881568.hostingersite.com/${review.foto}'),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Card(
                                color: Colors.grey[50],
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.nama_film!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // Tampilkan rating dengan bintang
                                      Row(
                                        children: List.generate(review.rating_film, (index) {
                                          return Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 20, // Ukuran bintang
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        review.komentar,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
