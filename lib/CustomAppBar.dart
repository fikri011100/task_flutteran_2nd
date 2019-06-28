import 'package:flutter/material.dart';
import 'package:task_flutteran_2nd/main.dart';

class CustomAppBar extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomBarItems = [];

  final bottomNavigationItemBarStyle =
      TextStyle(fontStyle: FontStyle.normal, color: Colors.black);

  CustomAppBar() {
    bottomBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(Icons.home, color: Colors.black),
        title: Text('Explore', style: bottomNavigationItemBarStyle)
      ),
    );
    bottomBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite, color: Colors.black),
        title: Text('Watchlist', style: bottomNavigationItemBarStyle)
      ),
    );
    bottomBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(Icons.local_offer, color: Colors.black),
        title: Text('Deals', style: bottomNavigationItemBarStyle)
      ),
    );
    bottomBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications, color: Colors.black),
        title: Text('Notifications', style: bottomNavigationItemBarStyle)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15.0,
      child: BottomNavigationBar(
        currentIndex: 0,
        items: bottomBarItems,
        type: BottomNavigationBarType.shifting,
      )
    );
  }
}
