import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedActivity = 'Ping Pong';
  int playerQuantity = 1;
  String selectedPaymentMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports Hall Booking'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              // Add functionality for profile action
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: Container(
        color: Colors.purple,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select Activity',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedActivity = 'Ping Pong';
                      });
                    },
                    style: selectedActivity == 'Ping Pong'
                        ? ElevatedButton.styleFrom(
                            backgroundColor: Colors.green)
                        : null,
                    child: const Text('Ping Pong'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedActivity = 'Badminton';
                      });
                    },
                    style: selectedActivity == 'Badminton'
                        ? ElevatedButton.styleFrom(
                            backgroundColor: Colors.green)
                        : null,
                    child: const Text('Badminton'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedActivity = 'Squash';
                      });
                    },
                    style: selectedActivity == 'Squash'
                        ? ElevatedButton.styleFrom(
                            backgroundColor: Colors.green)
                        : null,
                    child: const Text('Squash'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Court Availability'),
                        content: const Column(
                          children: [
                            Text(
                              'Available Courts:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text('Court A'),
                            Text('Court B'),
                            Text('Court C'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Show Court Availability'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Number of Players',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (playerQuantity > 1) {
                          playerQuantity--;
                        }
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    '$playerQuantity',
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (playerQuantity < 6) {
                          playerQuantity++;
                        }
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  ListTile(
                    title: const Text('Cash'),
                    leading: Radio(
                      value: 'Cash',
                      groupValue: selectedPaymentMethod,
                      onChanged: (String? value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Free'),
                    leading: Radio(
                      value: 'Free',
                      groupValue: selectedPaymentMethod,
                      onChanged: (String? value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Online'),
                    leading: Radio(
                      value: 'Online',
                      groupValue: selectedPaymentMethod,
                      onChanged: (String? value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement payment logic here
                  print('Selected Payment Method: $selectedPaymentMethod');
                },
                child: const Text('Make Payment'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}