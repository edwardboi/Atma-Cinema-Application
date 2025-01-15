import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:main/client/ReviewClient.dart';
import 'package:main/client/TicketClient.dart';
import 'package:main/client/UserClient.dart';
import 'package:main/entity/review.dart';
import 'package:main/entity/ticket.dart';
import 'package:main/entity/user.dart';

import 'package:main/view/pemesanan/reviewTiket.dart';
import 'package:main/view/pemesanan/ticket_detail.dart';

class TiketHome extends StatefulWidget {
  @override
  _TiketHomeState createState() => _TiketHomeState();
}

class _TiketHomeState extends State<TiketHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late Future<List<Ticket>> _ticketsFuture;
  late Future<User> _currentUser; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _currentUser = UserClient.fetchCurrentUser(); 

    // _ticketsFuture = TicketClient.fetchByUser(_currentUser.then((value) => value.id));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 33, 61, 41),
        title: Text(
          'My Tickets',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
          ),
        ),
      ),
      body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Color.fromARGB(255, 33, 61, 41),
                labelColor: Color.fromARGB(255, 33, 61, 41),
                tabs: [
                  Tab(text: 'Active Ticket'),
            Tab(text: 'Watch History'),
                ],
              ),
            ),
      Expanded(
        child:  FutureBuilder<User>(
            future: _currentUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('User tidak ditemukan'));
              } else {
                final User user = snapshot.data!;

                return TabBarView(
                  controller: _tabController,
                  children: [
                    ActiveTicketTab(user: user),
                    WatchHistoryTab(user: user),
                  ],
                );
              }
            },
          ),
          
        )
        ],
      )
      );
  }
}

class ActiveTicketTab extends StatelessWidget {
  final User user;

  const ActiveTicketTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    List<Ticket> tickets = [];

    return FutureBuilder<List<Ticket>>(
      future: TicketClient.fetchByUser(user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('Tidak ada data tiket'));
        } else  {
          tickets = snapshot.data!;

          DateTime now = DateTime.now();

          tickets = tickets.where((ticket) {
            List<String> timeParts = ticket.jam!.split(':'); 
            DateTime ticketDateTime = ticket.tanggal_tayang!.copyWith(
              hour: int.parse(timeParts[0]), // Jam
              minute: int.parse(timeParts[1]), // Menit
            );

            return ticketDateTime.isAfter(now);
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: List.generate(tickets.length, (int index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                  child: TicketCard1(ticket: tickets[index]),
                );
              }),
            ),
          );
        } 
      },
    );
    
  }
}

class WatchHistoryTab extends StatelessWidget {
  final User user;

  const WatchHistoryTab({super.key, required this.user});
  
  @override
  Widget build(BuildContext context) {
    List<Ticket> tickets = [];
    List<Ticket> history = [];

    return FutureBuilder<List<Ticket>>(
      future: TicketClient.fetchByUser(user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No Data'));
        } else  {
          tickets = snapshot.data!;

          DateTime now = DateTime.now();

          history = tickets.where((ticket) {
            List<String> timeParts = ticket.jam!.split(':');
            DateTime ticketDateTime = ticket.tanggal_tayang!.copyWith(
              hour: int.parse(timeParts[0]), // Jam
              minute: int.parse(timeParts[1]), // Menit
            );

            return ticketDateTime.isBefore(now);
          }).toList();


          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: List.generate(history.length, (int index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                  child: HistoryCard1(history: history[index]),
                );
              }),
            ),
          );
        } 
      },
    );
  }
}

class TicketCard1 extends StatelessWidget {
  final Ticket ticket;

  const TicketCard1({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("${ticket.gambar_film}"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${ticket.nama_film}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('ATMA CINEMA'),
                    Text('${ticket.jumlahKursi} Tiket'),
                    Text(DateFormat('EEEE, dd MMMM yyyy').format(ticket.tanggal_tayang!)),
                    Text('${ticket.jam}'),
                  ],
                ),
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TicketDetail(ticket: ticket)), 
                      );
                    },
                    child: Text('Detail'),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 33, 61, 41),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryCard1 extends StatelessWidget {
  final Ticket history;

  const HistoryCard1({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    // final Future<Review> review = ReviewClient.fetchByTiket(history.id!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<Review>(
            future: ReviewClient.fetchByTiket(history.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); 
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.id == null) {
                return Text("Review tidak ditemukan");
              } else {
                final review = snapshot.data!;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("${history.gambar_film}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${history.nama_film}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('ATMA CINEMA'),
                          Text('${history.jumlahKursi} Tiket'),
                          Text(DateFormat('EEEE, dd MMMM yyyy').format(history.tanggal_tayang!)),
                          Text('${history.jam}'),
                          review.id != 0 ? 
                            Row(
                              children: List.generate(review.rating_film, (index) {
                                return Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }),
                            )
                          :
                            SizedBox(width: 0),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        review.id == 0 ? 
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReviewTiket(history: history)), 
                              );
                            }, 
                            style: TextButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 33, 61, 41),
                                foregroundColor: Colors.white),
                            child: Text('Rate'),
                          )
                        : 
                          SizedBox(width: 0),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TicketDetail(ticket: history)), 
                            );
                          },
                          child: Text('Detail'),
                          style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 33, 61, 41),
                              foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          )
        ),
      )
    );
  }
}
