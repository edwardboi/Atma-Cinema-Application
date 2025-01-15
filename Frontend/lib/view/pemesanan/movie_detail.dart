import 'package:flutter/material.dart';
import 'package:main/client/JadwalClient.dart';
import 'package:main/client/PemesananClient.dart';
import 'package:main/client/ReviewClient.dart';
import 'package:main/client/StudioClient.dart';
import 'package:main/client/JamClient.dart';
import 'package:main/client/JamTayangClient.dart';
import 'package:main/entity/film.dart';
import 'package:main/entity/studio.dart';
import 'package:main/entity/jadwal.dart';
import 'package:main/entity/jam.dart';
import 'package:main/entity/jamTayang.dart';

import 'package:main/view/pemesanan/book_seat.dart';
import 'package:intl/intl.dart';
import 'package:main/view/pemesanan/movie_review.dart'; 

class MovieDetailsPage extends StatefulWidget {
  final Film film;

  const MovieDetailsPage({super.key, required this.film});

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> with SingleTickerProviderStateMixin {
  int selectedDateIndex = 0;
  bool isLoading = false;

  String? selectedTime;
  List<Jadwal> schedules = [];
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _isSliverAppBarExpanded = false;
  late JamTayang selectedJamTayang;
  late Jadwal selectedJadwal;

  late List<Future<List<JamTayang>>> _jamTayangsFutures;
  late Future<List<Studio>> _studiosFuture;
  late Future<List<Jadwal>> _jadwalsFuture;

  late Future<double> _rataRatingFuture;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _isSliverAppBarExpanded = _scrollController.offset > 100; 
      });
    });

    _rataRatingFuture = ReviewClient.getAverageRating(widget.film.id);

    _jamTayangsFutures = [
      JamTayangClient.fetchJamTayangsByStudioId(1),
      JamTayangClient.fetchJamTayangsByStudioId(2),
      JamTayangClient.fetchJamTayangsByStudioId(3),
      JamTayangClient.fetchJamTayangsByStudioId(4),
    ];
    _studiosFuture = StudioClient.fetchAll();
    _jadwalsFuture = JadwalClient.fetchJadwalHariIni();

    // buat jam tayang kalau lewat jadi false
    Future.wait(_jamTayangsFutures).then((List<List<JamTayang>> results) async {
      var jadwals = await _jadwalsFuture;

      int idJadwal = jadwals[0].id;
      
      setState(() {
        isLoading = true;

        for (var value in results.expand((x) => x)) {
          var jamString = value.jam;
          var now = DateTime.now();
          var timeParts = jamString.split(":");
          var jam = int.parse(timeParts[0]);
          var menit = int.parse(timeParts[1]);
          var jamTayang = DateTime(now.year, now.month, now.day, jam, menit);

          if (jamTayang.isBefore(now)) {
            value.isAvailable = false;
          }

          PemesananClient.getSisaKapasitas(
            idJadwal: idJadwal,
            idStudio: value.id_studio,
            idJamTayang: value.id,
            idFilm: widget.film.id,
          ).then((sisaKapasitas) {
            if (sisaKapasitas <= 0) {
              value.isAvailable = false;
            }
          }).catchError((error) {
            print('Error fetching kapasitas: $error');
          });
        
        }

        setState(() {
          isLoading = false; 
        });
      });
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      Future.wait(_jamTayangsFutures).then((List<List<JamTayang>> results) async {
        var jadwals = await _jadwalsFuture;
        int idJadwal = jadwals[0].id;
        selectedJadwal = jadwals[0];

        setState(() {
          for (var value in results.expand((x) => x)) {
            var jamString = value.jam;
            var now = DateTime.now();
            var timeParts = jamString.split(":");
            var jam = int.parse(timeParts[0]);
            var menit = int.parse(timeParts[1]);
            var jamTayang = DateTime(now.year, now.month, now.day, jam, menit);

            if (jamTayang.isBefore(now)) {
              value.isAvailable = false;
            }

            PemesananClient.getSisaKapasitas(
              idJadwal: idJadwal,
              idStudio: value.id_studio,
              idJamTayang: value.id,
              idFilm: widget.film.id,
            ).then((sisaKapasitas) {
              if (sisaKapasitas <= 0) {
               
                value.isAvailable = false;
              }
            }).catchError((error) {
              print('Error fetching kapasitas: $error');
            });
          }
        });

        setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        print('Error fetching jadwal or jam tayang: $error');
        setState(() {
          isLoading = false;
        });
      });
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _jamTayangsFutures.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: _isSliverAppBarExpanded ? Text(widget.film.nama_film, style: TextStyle(color: Colors.white)) : null,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: Colors.white, 
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); 
                },
              ),
            ),
            backgroundColor: Color.fromARGB(255, 33, 61, 41),
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.film.gambar_film,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // film Information Section
                Container(
                  padding: EdgeInsets.all(10.0),
                  color: Color.fromARGB(250, 33, 61, 41),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.film.gambar_film),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Atma Cinema',
                              style: TextStyle(
                                color: Color.fromARGB(255, 219, 196, 127),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.film.nama_film,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              color: const Color.fromARGB(255, 0, 255, 0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                                child: Text(
                                  widget.film.rating_usia,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              widget.film.genre,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                            Row(
                              children: [
                                Text(
                                  widget.film.durasi,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                  softWrap: true,  
                                  overflow: TextOverflow.visible,
                                ),
                                SizedBox(width: 20.0),
                
                                FutureBuilder<double>(
                                  future: _rataRatingFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      final avgRating = snapshot.data!;

                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MovieReview(film: widget.film, avgRating: avgRating),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.3, 
                                              height: MediaQuery.of(context).size.height * 0.08, 
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(255, 25, 49, 32),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0), 
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center, 
                                                  children: [
                                                    Text(
                                                      '$avgRating',
                                                      style: TextStyle(
                                                        color: Colors.yellow,
                                                        fontSize: MediaQuery.of(context).size.width * 0.07,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          
                                          // Logo Bintang
                                          Positioned(
                                            top: -(MediaQuery.of(context).size.height * 0.03), 
                                            left: -(MediaQuery.of(context).size.width * 0.05), 
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: MediaQuery.of(context).size.width * 0.12,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MovieReview(film: widget.film, avgRating: 0.0),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.3, 
                                              height: MediaQuery.of(context).size.height * 0.08, 
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(255, 25, 49, 32),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0), 
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center, 
                                                  children: [
                                                    Text(
                                                      '0',
                                                      style: TextStyle(
                                                        color: Colors.yellow,
                                                        fontSize: MediaQuery.of(context).size.width * 0.07,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          
                                          // Logo Bintang
                                          Positioned(
                                            top: -(MediaQuery.of(context).size.height * 0.03), 
                                            left: -(MediaQuery.of(context).size.width * 0.05), 
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: MediaQuery.of(context).size.width * 0.12,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                )
                                
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),

                // Tabs Section
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: "Synopsis"),
                          Tab(text: "Schedule"),
                        ],
                      ),
                      Container(
                        height: 800.0,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Synopsis Tab
                            SingleChildScrollView(
                              padding: EdgeInsets.all(10),
                              child : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      widget.film.sinopsis,
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Cast",
                                        style: TextStyle(
                                          fontSize: 20.0, 
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(widget.film.cast),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),

                            // Schedule Tab
                            widget.film.status == "Now Playing" ?
                              isLoading
                              ? Center(child: CircularProgressIndicator())
                              : Column(
                                children: [
                                  // Pilihan Hari
                                  Container(
                                    height: 80,
                                    child: FutureBuilder<List<Jadwal>>(
                                      future: _jadwalsFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Center(child: CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(child: Text('Error: ${snapshot.error}'));
                                        } else if (snapshot.hasData) {
                                          schedules = snapshot.data!;
                                          // selectedJadwal = schedules[0];
                                          
                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 6,
                                            itemBuilder: (context, index) {
                                              final jadwals = snapshot.data!;
                                              final semuaJamTayang = _jamTayangsFutures;

                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    
                                                    selectedDateIndex = index;
                                                    selectedTime = null; 
                                                    selectedJadwal = jadwals[index];
                                                    print(selectedJadwal.tanggal_tayang);
                                                    print(selectedJadwal.id);

                                                    isLoading = true;

                                                    Future.wait(_jamTayangsFutures).then((List<List<JamTayang>> results) {
                                                      List<Future> kapasitasFutures = [];

                                                      setState(() {
                                                       
                                                        for (var value in results.expand((x) => x)) {
                                                          var jamString = value.jam;
                                                          var now = DateTime.now();
                                                          var timeParts = jamString.split(":");
                                                          var jam = int.parse(timeParts[0]);
                                                          var menit = int.parse(timeParts[1]);
                                                          var jamTayang = DateTime(now.year, now.month, now.day, jam, menit);

                                                          if (jamTayang.isBefore(now)) {
                                                            value.isAvailable = false;
                                                          }

                                                          var kapasitasFuture = PemesananClient.getSisaKapasitas(
                                                            idJadwal: selectedJadwal.id,
                                                            idStudio: value.id_studio,
                                                            idJamTayang: value.id,
                                                            idFilm: widget.film.id,
                                                          ).then((sisaKapasitas) {
                                                            if (sisaKapasitas <= 0) {
                                                              print(sisaKapasitas);
                                                              setState(() {
                                                                value.isAvailable = false;
                                                              });
                                                            }
                                                          }).catchError((error) {
                                                            print('Error fetching kapasitas: $error');
                                                          });

                                                          kapasitasFutures.add(kapasitasFuture);
                                                        }
                                                      });

                                                      Future.wait(kapasitasFutures).then((_) {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      });
                                                    });

                                                    // buat reset jam tayang
                                                    for (var future in semuaJamTayang) {
                                                      future.then((s) {
                                                        for (var t in s) { 
                                                          t.isSelected = false;
                                                          if(selectedDateIndex != 0){
                                                            t.isAvailable = true;
                                                          } 
                                                        }
                                                      });
                                                    }
                    
                                                  });
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                                                  decoration: BoxDecoration(
                                                    color: index == selectedDateIndex
                                                        ? Color.fromARGB(255, 68, 90, 74)
                                                        : Colors.grey[300],
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        DateFormat('dd MMM').format(jadwals[index].tanggal_tayang),
                                                        style: TextStyle(
                                                          color: index == selectedDateIndex ? Colors.white : Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        index == 0 
                                                          ? 'Today' 
                                                          : '${DateFormat('EEE').format(jadwals[index].tanggal_tayang)}',
                                                        style: TextStyle(
                                                          color: index == selectedDateIndex ? Colors.white : Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          return Center(child: Text('No Data'));
                                        }
                                      },
                                    ),
                                  ),
                                  Divider(),
                                  
                                  // Jadwal Studio
                                  isLoading 
                                    ? Center(child: CircularProgressIndicator())
                                    : 
                                    Expanded(
                                    child: FutureBuilder<List<Studio>>(
                                      future: _studiosFuture, 
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Center(child: CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(child: Text('Error: ${snapshot.error}'));
                                        } else if (snapshot.hasData) {
                                          final studios = snapshot.data!;
                                          return ListView.builder(
                                            itemCount: studios.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${studios[index].tipe_studio} - Rp${studios[index].harga}',
                                                        // NumberFormat('#,##0').format()
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      SizedBox(height: 8.0),
                                                      Padding(
                                                        padding: const EdgeInsets.all(1.0),
                                                        child: FutureBuilder<List<JamTayang>>(
                                                          future: _jamTayangsFutures[index],
                                                          builder: (context, snapshot) {
                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                              return Center(child: CircularProgressIndicator());
                                                            } else if (snapshot.hasError) {
                                                              return Center(child: Text('Error: ${snapshot.error}'));
                                                            } else if (snapshot.hasData) {
                                                              final jamTayangs = snapshot.data!;
                                                              final semuaJamTayang = _jamTayangsFutures;
                                                              
                                                              return Wrap(
                                                                spacing: 8.0,
                                                                runSpacing: 8.0,
                                                                children: jamTayangs.map((jamTayang) {
                                                                  final slot = jamTayang.jam; 

                                                                  return GestureDetector(
                                                                    onTap: jamTayang.isAvailable
                                                                        ? jamTayang.isSelected
                                                                            ? () {
                                                                                setState(() {
                                                                                  jamTayang.isSelected = false; 
                                                                                  selectedTime = null; 
                                                                                });
                                                                              }
                                                                            : () {
                                                                                setState(() {
                                                                                  for (var future in semuaJamTayang) {
                                                                                    future.then((s) {
                                                                                      for (var t in s) {
                                                                                        t.isSelected = false;
                                                                                        print(t.id);
                                                                                        if(t.jam == jamTayang.jam) {
                                                                                          t.isSelected = true; 
                                                                                          selectedTime = t.jam; 
                                                                                          selectedJamTayang = t;
                                                                                        }
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                  // jamTayang.isSelected = true; 
                                                                                  // selectedTime = jamTayang.jam; 
                                                                                });
                                                                              }
                                                                        : null,
                                                                    child: Container(
                                                                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                                                      decoration: BoxDecoration(
                                                                        color: jamTayang.isSelected
                                                                            ? Color.fromARGB(255, 68, 90, 74)
                                                                            : jamTayang.isAvailable
                                                                                ? Colors.grey[300] 
                                                                                : Colors.grey[700],
                                                                        borderRadius: BorderRadius.circular(5.0),
                                                                      ),
                                                                      child: Text(
                                                                        jamTayang.jam,
                                                                        style: TextStyle(
                                                                          color: jamTayang.isAvailable
                                                                              ? jamTayang.isSelected ? Colors.white : Colors.black
                                                                              : Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              );
                                                            } else {
                                                              return Center(child: Text('No Data'));
                                                            }
                                                          },
                                                        ),  
                                                      ),
                                                      Divider(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          return Center(child: Text('No Data'));
                                        }
                                      },
                                    
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                              padding: EdgeInsets.all(50.0),
                              child: Text(
                                "Sorry, currrently there is no available schedules",
                                style: TextStyle(
                                  color: Colors.grey[500]
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Tombol Booking seat
      bottomNavigationBar: 
        _tabController.index == 1 ? 
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: ElevatedButton(
            
              onPressed: selectedTime != null
                  ? () {
                      print(selectedJadwal.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookSeat(film: widget.film, jamTayang: selectedJamTayang, jadwal: selectedJadwal)),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 33, 61, 41),
                disabledBackgroundColor: Colors.grey,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text(
                "Book Seat",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          )
        : null,
    );
  }
}