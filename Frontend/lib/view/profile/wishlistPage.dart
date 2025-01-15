import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:main/client/WishlistClient.dart';
import 'package:main/entity/wishlist.dart';
import 'package:main/entity/user.dart';
import 'package:main/client/UserClient.dart';
import 'package:main/view/home/welcome.dart';

class Wishlistpage extends ConsumerWidget {
  bool isFavorited = true;
  Wishlistpage({super.key});

  final currentUserProvider = FutureProvider<User>((ref) async {
    return await UserClient.fetchCurrentUser();
  });

  final listWishlistProvider =
      FutureProvider.family<List<Wishlist>, int>((ref, idUser) async {
    return await WishlistClient.fetchByUser(idUser);
  });

  // Hapus
  void onDelete(id, context, ref) async {
    try {
      await WishlistClient.destroy(id);
      ref.invalidate(listWishlistProvider);
      showSnackBar(context, "Remove Wishlist", Colors.green);
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 61, 41),
        title: Text(
          'Wishlist',
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
        data: (user) {
          final wishlistListener = ref.watch(listWishlistProvider(user.id));
          return wishlistListener.when(
            data: (wishlist) {
              if (wishlist.isEmpty) {
                return Center(
                  child: Text(
                    'Masih tidak ada',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                );
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0.5,
                  mainAxisSpacing: 0.5,
                  childAspectRatio: 0.45,
                ),
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final dataWishlist = wishlist[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, right: 10.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                width: 200,
                                height: 350,
                                child: Image.asset(
                                  dataWishlist.gambar_film,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      isFavorited ? Colors.red : Colors.white,
                                ),
                                onPressed: () =>
                                    onDelete(dataWishlist.id, context, ref),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              dataWishlist.nama_film,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              dataWishlist.genre,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error fetching user data: $e')),
      ),
    );
  }
}

void showSnackBar(BuildContext context, String message, MaterialColor color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}
