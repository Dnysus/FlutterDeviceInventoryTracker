import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InventoryTracker(),
    );
  }
}

class InventoryTracker extends StatelessWidget {
  final List<Location> locations = [
    // Add more locations here
    Location('Location 1', {
      'Item 1': 22,
      'Item 2': 175,
      'Item 3': 78,
      'Item 4': 6,
      'Item 5': 350,
    }),
    Location('Location 2', {
      'Item 1': 15,
      'Item 2': 10,
      'Item 3': 67,
      'Item 4': 32,
      'Item 5': 35,
    }),
    Location('Location 3', {
      'Item 1': 26,
      'Item 2': 17,
      'Item 3': 72,
      'Item 4': 60,
      'Item 5': 5,
    }),
    Location('Location 4', {
      'Item 1': 1,
      'Item 2': 2,
      'Item 3': 3,
      'Item 4': 4,
      'Item 5': 5,
    }),
  ];

  // Sort locations based on the total inventory count in descending order
  List<Location> getSortedLocations() {
    return List<Location>.from(locations)..sort((Location a, Location b) {
      int totalA = a.inventory.values.fold(0, (sum, current) => sum + current);
      int totalB = b.inventory.values.fold(0, (sum, current) => sum + current);
      return totalB.compareTo(totalA); // For descending order
    });
  }

  Map<String, int> calculateTotalInventory() {
  Map<String, int> totals = {};
  for (var location in locations) {
    location.inventory.forEach((key, value) {
      // Use the null-aware spread operator to ensure we're dealing with non-null values
      totals[key] = (totals[key] ?? 0) + value;
    });
  }
  return totals;
}


  @override
  Widget build(BuildContext context) {
    Map<String, int> totalInventory = calculateTotalInventory();
    // Use the sorted locations list for displaying
    List<Location> sortedLocations = getSortedLocations();

    return Scaffold(
      appBar: AppBar(
        title: Text('Total Inventory'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InventorySummary(totalInventory: totalInventory),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
              ),
              itemCount: sortedLocations.length,
              itemBuilder: (context, index) {
                return LocationCard(location: sortedLocations[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InventorySummary extends StatelessWidget {
  final Map<String, int> totalInventory;

  InventorySummary({required this.totalInventory});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 16.0,
        runSpacing: 16.0,
        children: totalInventory.entries.map((entry) {
          IconData icon;
          //Add more Icons here
          switch (entry.key) {
            case 'Item 1':
              icon = Icons.laptop;
              break;
            case 'Item 2':
              icon = Icons.tablet_mac;
              break;
            case 'Item 3':
              icon = Icons.keyboard;
              break;
            case 'Item 4':
              icon = Icons.laptop_mac;
              break;
            case 'Item 5':
              icon = Icons.recycling;
              break;
            default:
              icon = Icons.device_unknown;
          }
          return InventoryItem(icon, entry.key, entry.value);
        }).toList(),
      ),
    );
  }
}

class InventoryItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final int count;

  InventoryItem(this.icon, this.name, this.count);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 50),
        SizedBox(height: 8),
        Text('x$count'),
        Text(name),
      ],
    );
  }
}

class Location {
  String name;
  Map<String, int> inventory;

  Location(this.name, this.inventory);
}

class LocationCard extends StatelessWidget {
  final Location location;

  LocationCard({required this.location});

  Color _getProgressBarColor(int itemCount) {
    if (itemCount < 10) {
      return Colors.blue;
    } else if (itemCount >= 10 && itemCount < 15) {
      return Colors.yellow;
    } else if (itemCount >= 15 && itemCount < 20) {
      return Colors.orange;
    } else { // itemCount >= 20
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(),
            ...location.inventory.keys.map((itemName) {
              int itemCount = location.inventory[itemName] ?? 0;
              Color progressBarColor = itemName == "Item 5" 
                ? _getProgressBarColor(itemCount) 
                : Colors.blue; // Default color for other items
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(itemName),
                        Text('x$itemCount'),
                      ],
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: itemCount / 200,
                      backgroundColor: Colors.grey[200],
                      color: progressBarColor,
                      minHeight: 10,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
