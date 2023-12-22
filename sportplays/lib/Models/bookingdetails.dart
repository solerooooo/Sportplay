//bookingdetails.dart
import 'package:uuid/uuid.dart';

class Booking {
  String bookingId;
  String selectedActivity = 'Ping Pong';
  int playerQuantity = 1;
  String selectedPaymentMethod = 'Cash';

  static Map<String, int> selectedCourts = {};

  Booking({required String selectedActivity, required int playerQuantity, required String selectedPaymentMethod})
      : bookingId = Uuid().v4(), // Generate a unique identifier using the uuid package
        super();

  static void updateAvailability(
      String time, int pingPongCourts, int badmintonCourts, int squashCourts) {
    selectedCourts['pingPong_$time'] = pingPongCourts;
    selectedCourts['badminton_$time'] = badmintonCourts;
    selectedCourts['squash_$time'] = squashCourts;
  }
}
