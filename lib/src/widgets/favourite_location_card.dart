import 'package:flutter/material.dart';

class FavouriteLocationCard extends StatefulWidget {
  const FavouriteLocationCard({super.key});

  @override
  State<FavouriteLocationCard> createState() => _FavouriteLocationCardState();
}

class _FavouriteLocationCardState extends State<FavouriteLocationCard> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 5,
                  offset: const Offset(3, 3))
            ]),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                Text("MOSMAN PARK, 6012, WA")
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.amber[900],
                  ),
                  const Text("Current Fire Danger Rating:"),
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      "Moderate",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),

            // Use the following block of code to display high/low temp, precipitation, and wind speed

            // const Padding(
            //   padding: EdgeInsets.fromLTRB(48, 32, 48, 32),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           Icon(
            //             Icons.thermostat_rounded,
            //             color: Colors.red, size: 42,
            //           ),
            //           Text('27', style: TextStyle(fontSize: 24))
            //         ],
            //       ),
            //       Row(
            //         children: [
            //           Icon(
            //             Icons.thermostat_rounded,
            //             color: Colors.blue, size: 42,
            //           ),
            //           Text('12', style: TextStyle(fontSize: 24))
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // const Padding(
            //   padding: EdgeInsets.fromLTRB(48, 0, 48, 0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           Icon(
            //             Icons.water_drop_rounded,
            //             color: Colors.blue, size: 32,
            //           ),
            //           Text('58mm', style: TextStyle(fontSize: 18))
            //         ],
            //       ),
            //       Row(
            //         children: [
            //           Icon(
            //             Icons.air_rounded,
            //             color: Colors.blueGrey, size: 32,
            //           ),
            //           Text('12km/hr', style: TextStyle(fontSize: 18))
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: viewLocation,
                    icon: Icon(
                      Icons.map_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    )),
                IconButton(
                    onPressed: () => showConfirmDelete(context),
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ],
            ),
          ],
        ));
  }

  Future<void> showConfirmDelete(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure you want to delete this location?"),
          content: const Text("This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: deleteLocation,
              child: const Text("Delete"),
            )
          ],
        );
      },
    );
  }

  void viewLocation() {
    // Open suburb in Home view
  }

  void deleteLocation() {
    Navigator.of(context).pop;
  }
}
