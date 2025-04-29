// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:bus_booking_app/models/bus_model.dart';
import 'package:bus_booking_app/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusDetailsScreen extends StatelessWidget {
  const BusDetailsScreen({super.key, required this.bus});
  final Bus bus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bus.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${bus.from}→${bus.to}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(
              'Departure Time: ${bus.departureTime}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Ticket Price: \$${bus.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Select Your Seat:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(child: SeatGrid(bus: bus)),
          ],
        ),
      ),
    );
  }
}

class SeatGrid extends StatefulWidget {
  final Bus bus;

  const SeatGrid({super.key, required this.bus});

  @override
  State<SeatGrid> createState() => _SeatGridState();
}

class _SeatGridState extends State<SeatGrid> {
  final List<bool> selectedseats = List.generate(40, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: selectedseats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedseats[index] = !selectedseats[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedseats[index] ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.deepPurple),
                  ),
                  alignment: Alignment.center,
                  child: Text('Seat ${index + 1}'),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final selectedSeatNumbers =
                  selectedseats
                      .asMap()
                      .entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key + 1)
                      .toList();

              if (selectedSeatNumbers.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select at least one seat.')),
                );
                return;
              }

              try {
                await FirebaseFirestore.instance.collection('bookings').add({
                  'busName': widget.bus.name,
                  'from': widget.bus.from,
                  'to': widget.bus.to,
                  'departureTime': widget.bus.departureTime,
                  'selectedSeats': selectedSeatNumbers,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Booking saved for seats: ${selectedSeatNumbers.join(', ')}',
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to save booking: $e')),
                );
                log("$e");
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: Text(
              "Proceed",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
