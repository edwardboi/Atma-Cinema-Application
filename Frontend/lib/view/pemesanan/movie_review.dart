import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:main/entity/film.dart';
import 'package:main/entity/review.dart';
import 'package:main/client/ReviewClient.dart';



class MovieReview extends ConsumerWidget {
  final Film film;
  final double avgRating;

  MovieReview({super.key, required this.film, required this.avgRating});
final listReviewsProvider = FutureProvider.family<List<Review>, int>((ref, filmId) async {
  final reviews = await ReviewClient.fetchByFilmId(filmId);
  return reviews;
});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final reviewListener = ref.watch(listReviewsProvider(film.id));
    // Provider untuk mengambil data review berdasarkan film

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 61, 41),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  film.nama_film,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              '$avgRating',
              style: TextStyle(
                fontSize: 28,
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: reviewListener.when(
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
                  return  Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage('https://ivory-stingray-881568.hostingersite.com/${review.foto}'),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Card(
                               color: Colors.grey[50],
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                              child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.nama,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: List.generate(review.rating_film, (index) {
                                    return Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20, // Ukuran bintang
                                    );
                                  }),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  review.komentar,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
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
      ),
    );
  }
}
