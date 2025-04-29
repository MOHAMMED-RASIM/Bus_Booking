import 'package:bus_booking_app/screens/profile.dart';
import 'package:bus_booking_app/screens/bus_details.dart';
import 'package:bus_booking_app/models/bus_model.dart';
import 'package:bus_booking_app/widgets/calendar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  bool showBuses = false;

  final List<Bus> busList = [
    Bus(
      name: "Express Line",
      from: "City A",
      to: "City B",
      departureTime: "08:00 AM",
      price: 15.0,
    ),
    Bus(
      name: "Swift Travels",
      from: "City A",
      to: "City C",
      departureTime: "09:30 AM",
      price: 18.0,
    ),
    Bus(
      name: "City Connect",
      from: "City B",
      to: "City D",
      departureTime: "10:15 AM",
      price: 20.0,
    ),
    Bus(
      name: "Fast Wheels",
      from: "City A",
      to: "City D",
      departureTime: "01:00 PM",
      price: 22.5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Book Your Bus'),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              icon: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'From',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_pin),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  DateTime? picked = await selectDate(context, selectedDate);
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Travel Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_month),
                  ),
                  child: Text('${selectedDate.toLocal()}'.split(' ')[0]),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showBuses = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Searching buses...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text(
                    'Search Buses',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (showBuses) ...[
                Text(
                  'Available Buses :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: busList.length,
                    itemBuilder: (context, index) {
                      final bus = busList[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            bus.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${bus.from} → ${bus.to}\nDeparts at: ${bus.departureTime}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BusDetailsScreen(bus: bus),
                              ),
                            );
                          },
                          trailing: Text('\$${bus.price.toStringAsFixed(2)}'),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
