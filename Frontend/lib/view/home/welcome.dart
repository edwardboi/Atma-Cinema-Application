import 'package:flutter/material.dart';
import 'package:main/view/home/fnb_list.dart';
import 'package:main/view/profile/profile.dart';
import 'package:main/view/home/isiHome.dart';
import 'package:main/view/home/movie_list.dart';
import 'package:main/view/home/tiket.dart';

  class Welcome extends StatefulWidget {
    final int selectedIndex;
    final int indextab;
    const Welcome({super.key, this.selectedIndex = 0, this.indextab=0});

    @override
    State<Welcome> createState() => _WelcomeState();
  }

  class _WelcomeState extends State<Welcome> {
    int _selectedIndex = 0;
    int indextab = 0;

    @override
    void initState(){
      super.initState();
      _selectedIndex = widget.selectedIndex;
      indextab = widget.indextab;
    }

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    

    @override
    Widget build(BuildContext context) {
      final List<Widget> _widgetOptions = <Widget>[
        isiHome(),
        MovieList(indextab: indextab),
        FnbList(),
        TiketHome(),
        ProfilHome(),
      ];
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.movie,
                ),
                label: 'Movies'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                ),
                label: 'List'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.confirmation_num,
              ),
              label: 'Ticket'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color.fromARGB(255, 33, 61, 41), 
          unselectedItemColor: Colors.grey, 
          backgroundColor: Colors.white, 
          type: BottomNavigationBarType.fixed, 
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      );
    }
  }
