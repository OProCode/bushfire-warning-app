import 'package:bushfire_warning_app/src/connector/local_storage_connector.dart';
import 'package:bushfire_warning_app/src/theme/theme_provider.dart';
import 'package:bushfire_warning_app/src/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../connector/fire_danger_rating_api_connector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// Settings page where users can update the app theme, location, notifications, and manage their account.

  void storeServerAddress(String value) {
    String serverAddress = value;
    if (value.endsWith("/")) {
      serverAddress = value.substring(0, value.length - 1);
    }
    LocalStorage().storeServerAddress(serverAddress);
  }

  Future<void> showConfirmLogout(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop;
                FireDangerRatingAPI().logout();
              },
              child: const Text("Logout"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = false;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const Text('SETTINGS',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Dark Mode',
            ),
            Switch(
                value: isDark,
                activeColor: Theme.of(context).colorScheme.secondary,
                onChanged: (bool value) {
                  setState(() {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                    isDark = !isDark;
                  });
                }),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Enable Location Services',
              // style: bodyStyle,
            ),
            Switch(
                value: true,
                activeColor: Theme.of(context).colorScheme.secondary,
                onChanged: (bool value) {
                  // setState(() {
                  //   gps = value;
                  // });
                }),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Show Current Location as Default"),
            Switch(
              value: false,
              onChanged: null,
            )
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Enable Push Notifications"),
            Switch(
              value: false,
              onChanged: null,
            )
          ],
        ),
        // const Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text("Enable Dynamic Theme"),
        //     Switch(
        //       value: false,
        //       onChanged: null,
        //     )
        //   ],
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Server Address"),
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: FutureBuilder(
                  future: LocalStorage().getServerAddress(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return TextFormField(
                        key: const Key("populatedServerAddressTextField"),
                        onChanged: storeServerAddress,
                        initialValue: snapshot.data,
                      );
                    } else {
                      return const Text("");
                    }
                  },
                ))
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 32.0, 0, 16.0),
              child: Text(
                "ACCOUNT",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
              child: FireDangerRatingAPI.isLoggedIn == true
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.account_circle_rounded,
                        size: 128,
                      ),
                    )
                  : null,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
              child: FireDangerRatingAPI.isLoggedIn == true
                  ? Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_rounded),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout_rounded),
                          onPressed: () {
                            showConfirmLogout(context);
                          },
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.login_rounded),
                          iconSize: 40,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                        ),
                      ],
                    ),
            )
          ],
        ),
      ]),
    );
  }
}
