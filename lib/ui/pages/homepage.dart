import 'package:cookable_flutter/ui/pages/fridge.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/private_recipes.dart';
import 'package:cookable_flutter/ui/pages/profile.dart';
import 'package:cookable_flutter/ui/pages/recipe/recipes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey globalKey;
  get error => null;

  int _selectedIndex = 1;
  static List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    globalKey = new GlobalKey();
    _widgetOptions = <Widget>[
      ToggleFridgeWidget(),
      RecipesComponent(),
      PrivateRecipesComponent(navBarKey: globalKey),
      ProfilePage(),
      //  ObjectDetectorView()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            key: globalKey,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/fridge32.png")),
                label: AppLocalizations.of(context).fridge,
                backgroundColor: Colors.teal,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.lunch_dining),
                label: AppLocalizations.of(context).recipes,
                backgroundColor: Colors.teal,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: AppLocalizations.of(context).yourRecipes,
                backgroundColor: Colors.teal,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: AppLocalizations.of(context).profile,
                backgroundColor: Colors.teal,
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.video_call_rounded),
              //   label: "ML",
              //   backgroundColor: Colors.teal
              // )
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _selectedIndex,
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
