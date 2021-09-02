import 'package:cookable_flutter/ui/components/fridgenew.component.dart';
import 'package:cookable_flutter/ui/components/recipes.component.dart';
import 'package:cookable_flutter/ui/pages/dashboard.dart';
import 'package:cookable_flutter/ui/pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get error => null;

  int _selectedIndex = 1;
  static List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    // FridgeComponent(),
    ToggleFridgeWidget(),
    RecipesComponent(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Friganto'),
          actions: [Icon(Icons.settings)],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.shopping_basket),
            //   label: 'Fridge',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Fridge 2',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lunch_dining),
              label: 'Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
