//bookingdetails.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  int bookingId;
  String selectedActivity;
  int playerQuantity;
  String selectedPaymentMethod;
  String selectedTime;
  Timestamp? timestamp; 
  final String? userName;
  bool? isCourtAssigned;
  final List<String>? playerNames;

  Booking({
    required this.bookingId,
    required this.selectedActivity,
    required this.playerQuantity,
    required this.selectedPaymentMethod,
    required this.selectedTime,
    this.timestamp,
    this.userName,
    required this.isCourtAssigned,
    required this.playerNames,
  });


}
