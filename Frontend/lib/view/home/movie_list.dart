import 'package:flutter/material.dart';
import 'package:main/client/UserClient.dart';
import 'package:main/view/pemesanan/movie_detail.dart';
import 'package:main/view/profile/profile.dart';

import 'package:main/entity/film.dart';
import 'package:main/client/FilmClient.dart';

import 'package:main/entity/user.dart';

import 'package:main/entity/wishlist.dart';
import 'package:main/client/WishlistClient.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

List<String> titles = <String>[
  'Now Playing',
  'Coming Soon',
];

final isFavoritedProvider = StateProvider<bool>((ref) => false);

class MovieList extends StatefulWidget {
  final int indextab;
  const MovieList({super.key, required this.indextab});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late Future<List<Film>> _filmsFuture;
  List<Film> films = [];
  List<Film> filmsNow = [];
  List<Film> filmsComing = [];

  @override
  void initState() {
    super.initState();

    _filmsFuture = FilmClient.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    const int tab = 2;

    return DefaultTabController(
      initialIndex: widget.indextab,
      length: tab,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 33, 61, 41),
          title: Text(
            'Movies',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: Color.fromARGB(255, 33, 61, 41),
                tabs: <Widget>[
                  Tab(text: titles[0]),
                  Tab(text: titles[1]),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Film>>(
                future: _filmsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    films = snapshot.data!;

                    filmsNow = films
                        .where((film) => film.status == "Now Playing")
                        .toList();
                    filmsComing = films
                        .where((film) => film.status == "Coming Soon")
                        .toList();

                    return TabBarView(
                      children: <Widget>[
                        MovieGrid(status: 'Now Playing', filmsFuture: filmsNow),
                        MovieGrid(
                            status: 'Coming Soon', filmsFuture: filmsComing),
                      ],
                    );
                  } else {
                    return Center(child: Text('No Data'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieGrid extends StatelessWidget {
  final String status;
  final List<Film> filmsFuture;

  const MovieGrid({Key? key, required this.status, required this.filmsFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 0.5,
        mainAxisSpacing: 0.5,
        childAspectRatio: 0.47,
      ),
      itemCount: filmsFuture.length,
      itemBuilder: (BuildContext context, int index) {
        final film = filmsFuture[index];
        return MovieItem(film: film);
      },
    );
  }
}

class MovieItem extends ConsumerStatefulWidget {
  final Film film;

  const MovieItem({Key? key, required this.film}) : super(key: key);

  @override
  _MovieItemState createState() => _MovieItemState();
}

class _MovieItemState extends ConsumerState<MovieItem> {
  bool isFavorited = false;
  int idWishlist = 0;

  final userProvider = FutureProvider<User>((ref) async {
    return await UserClient.fetchCurrentUser();
  });

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  // Mengecek apakah film sudah ada dalam wishlist
  void _checkIfFavorited() async {
    try {
      final user = await ref.read(userProvider.future);

      if (user == null) {
        print("User data is null");
        return;
      }

      final wishlistId = await WishlistClient.findWishlistIdByFilmAndUser(
          widget.film.id, user.id);

      setState(() {
        isFavorited = wishlistId != null;
      });
    } catch (e) {
      print("Error checking if film is favorited: $e");
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

  // Hapus dari wishlist
  void onDelete(int id, BuildContext context) async {
    try {
      await WishlistClient.destroy(id);
      setState(() {
        isFavorited = false;
      });
      showSnackBar(context, "Film removed from wishlist", Colors.green);
    } catch (e) {
      showSnackBar(context, "Error: $e", Colors.red);
    }
  }

  // Tambah ke wishlist
  void onAdd(User user, BuildContext context) async {
    int? wishlistId = await WishlistClient.findWishlistIdByFilmAndUser(
        widget.film.id, user.id);
    if (wishlistId != null) {
      idWishlist = wishlistId + 1;
    } else {
      print("Wishlist tidak ditemukan untuk film ini dan pengguna tersebut.");
    }

    Wishlist input = Wishlist(
      id: idWishlist,
      id_film: widget.film.id,
      id_user: user.id,
      nama_film: widget.film.nama_film,
      durasi: widget.film.durasi,
      genre: widget.film.genre,
      sinopsis: widget.film.sinopsis,
      rating_film: widget.film.rating_film,
      rating_usia: widget.film.rating_usia,
      cast: widget.film.cast,
      gambar_film: widget.film.gambar_film,
      status: widget.film.status,
    );

    try {
      await WishlistClient.create(input);
      setState(() {
        isFavorited = true;
      });
      showSnackBar(context, "Film added to wishlist", Colors.green);
    } catch (e) {
      showSnackBar(context, "Error: $e", Colors.red);
    }
  }

  void onFavoritePressed(BuildContext context, WidgetRef ref) async {
    final userAsync = ref.watch(userProvider);

    userAsync.when(
      data: (user) async {
        if (isFavorited) {
          int? wishlistId = await WishlistClient.findWishlistIdByFilmAndUser(
              widget.film.id, user.id);
          if (wishlistId != null) {
            onDelete(wishlistId, context);
          }
        } else {
          onAdd(user, context);
        }

        _checkIfFavorited();
      },
      error: (error, stackTrace) {
        showSnackBar(context, "Error: $error", Colors.red);
      },
      loading: () {
        showSnackBar(context, "Loading user data...", Colors.orange);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsPage(
                        film: widget.film,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: 200,
                    height: 350,
                    child: Image.asset(
                      widget.film.gambar_film,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited ? Colors.red : Colors.white,
                  ),
                  onPressed: () => onFavoritePressed(context, ref),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            children: [
              Text(
                widget.film.nama_film,
                textAlign: TextAlign.center,
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                ),
              ),
              Text(
                widget.film.genre,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
