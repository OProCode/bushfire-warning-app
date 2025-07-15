import 'package:flutter/material.dart';
import 'package:bushfire_warning_app/src/widgets/settings_page.dart';
import 'package:bushfire_warning_app/src/widgets/homepage/home_page.dart';
import 'package:bushfire_warning_app/src/widgets/favourite_locations.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 1;

  Widget _getNavigationBarItem() {
    List<Widget> widgetOptions = [
      const SettingsPage(),
      const HomePage(),
      const FavouriteLocations(),
    ];
    return widgetOptions[_selectedIndex];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // TODO: Implement SafeArea without pushing content down

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "IN THE EVENT OF AN EMERGENCY CALL ",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "000",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Stack(
            children: [
              _getNavigationBarItem(),
              SizedBox(
                height: MediaQuery.of(context).size.height - 36,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    ClipPath(
                      clipper: WaveClipperOne(reverse: true),
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [(Colors.amber[900])!, Colors.red],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter)),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            (Theme.of(context).colorScheme.secondary),
                            (Theme.of(context).colorScheme.tertiary),
                          ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter)),
                      child: BottomNavigationBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        selectedItemColor: Colors.grey.shade100,
                        unselectedItemColor: Colors.amber.shade200,
                        selectedIconTheme: const IconThemeData(size: 42),
                        unselectedIconTheme: const IconThemeData(size: 24),
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        enableFeedback: false,
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(
                              Icons.settings_rounded,
                            ),
                            label: 'Settings',
                          ),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.home_rounded), label: 'Home'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.location_on_rounded),
                              label: 'My Locations'),
                        ],
                        currentIndex: _selectedIndex,
                        onTap: _onItemTapped,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
