import 'package:bushfire_warning_app/src/widgets/favourite_location_card.dart';
import 'package:flutter/material.dart';

class FavouriteLocations extends StatefulWidget {
  const FavouriteLocations({super.key});

  @override
  State<FavouriteLocations> createState() => _FavouriteLocationsState();
}

class _FavouriteLocationsState extends State<FavouriteLocations> {
  Map myLocations = {
    "MOSMAN PARK": {
      "postcode": 6012,
      "fireDangerRating": {"level": "Moderate", "score": 32},
      "weather": {"minTemp": 11, "maxTemp": 32, "rain": 22, "wind": "32km NSW"}
    }
  };

  @override
  Widget build(BuildContext context) {
    return Container(      
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            const Text("My Locations",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text("Last Issued At: 4:10 PM Wednesday 22nd May, 2024",
                style: TextStyle(
                  color: Colors.grey[500]
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: FavouriteLocationCard(),
            ),
            const FavouriteLocationCard()
          ],
        )
      )
    );
  }
}
